const { S3Client, PutObjectCommand } = require('@aws-sdk/client-s3');
const Busboy = require('busboy');
const { v4: uuidv4 } = require('uuid');

const s3Client = new S3Client({ region: process.env.AWS_REGION });

exports.handler = async (event) => {
    console.log('Event:', JSON.stringify(event, null, 2));

    const contentType = event.headers['content-type'] || event.headers['Content-Type'];

    if (!contentType || !contentType.includes('multipart/form-data')) {
        return {
            statusCode: 400,
            headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            body: JSON.stringify({ error: 'Content-Type must be multipart/form-data' })
        };
    }

    return new Promise((resolve, reject) => {
        const busboy = Busboy({ headers: { 'content-type': contentType } });
        const uploads = [];
        const promises = [];

        busboy.on('file', (fieldname, file, info) => {
            const { filename, mimeType } = info;

            // Validar tipo de archivo
            const allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
            if (!allowedTypes.includes(mimeType)) {
                file.resume();
                return;
            }

            const chunks = [];

            file.on('data', (data) => {
                chunks.push(data);
            });

            const uploadPromise = new Promise((resolveFile, rejectFile) => {
                file.on('end', async () => {
                    try {
                        const buffer = Buffer.concat(chunks);
                        const fileSize = buffer.length;

                        // Validar tamaño (10MB max)
                        if (fileSize > 10 * 1024 * 1024) {
                            throw new Error('File size exceeds 10MB limit');
                        }

                        const fileId = uuidv4();
                        const extension = filename.split('.').pop();
                        const key = `uploads/${fileId}.${extension}`;

                        await s3Client.send(new PutObjectCommand({
                            Bucket: process.env.S3_BUCKET,
                            Key: key,
                            Body: buffer,
                            ContentType: mimeType,
                            Metadata: {
                                'original-filename': filename,
                                'upload-timestamp': new Date().toISOString()
                            }
                        }));

                        uploads.push({
                            fileId,
                            filename,
                            size: fileSize,
                            type: mimeType,
                            s3Key: key
                        });
                        resolveFile();
                    } catch (error) {
                        console.error('Upload error:', error);
                        rejectFile(error);
                    }
                });
            });
            promises.push(uploadPromise);
        });

        busboy.on('finish', async () => {
            try {
                await Promise.all(promises);
                resolve({
                    statusCode: 200,
                    headers: {
                        'Content-Type': 'application/json',
                        'Access-Control-Allow-Origin': '*'
                    },
                    body: JSON.stringify({
                        message: 'Upload successful',
                        files: uploads
                    })
                });
            } catch (error) {
                resolve({
                    statusCode: 500,
                    headers: {
                        'Content-Type': 'application/json',
                        'Access-Control-Allow-Origin': '*'
                    },
                    body: JSON.stringify({ error: error.message })
                });
            }
        });

        busboy.on('error', (error) => {
            console.error('Busboy error:', error);
            resolve({
                statusCode: 500,
                headers: {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
                body: JSON.stringify({ error: error.message })
            });
        });

        const bodyBuffer = Buffer.from(event.body, event.isBase64Encoded ? 'base64' : 'utf8');
        busboy.write(bodyBuffer);
        busboy.end();
    });
};