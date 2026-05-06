const { S3Client, GetObjectCommand, PutObjectCommand } = require('@aws-sdk/client-s3');
const sharp = require('sharp');

const s3Client = new S3Client({ region: process.env.AWS_REGION });

exports.handler = async (event) => {
    console.log('Event:', JSON.stringify(event, null, 2));

    const results = [];

    for (const record of event.Records) {
        try {
            const message = JSON.parse(record.body);
            const s3Event = message.Records[0].s3;
            const bucket = s3Event.bucket.name;
            const key = decodeURIComponent(s3Event.object.key.replace(/\+/g, ' '));

            console.log(`Processing: ${bucket}/${key}`);

            // Download image from S3
            const getCommand = new GetObjectCommand({
                Bucket: bucket,
                Key: key
            });

            const { Body } = await s3Client.send(getCommand);
            const imageBuffer = await streamToBuffer(Body);

            // Create circular 40x40 PNG
            const circleBuffer = await sharp(imageBuffer)
                .resize(40, 40, {
                    fit: 'cover',
                    position: 'center'
                })
                .composite([{
                    input: Buffer.from(
                        '<svg><circle cx="20" cy="20" r="20"/></svg>'
                    ),
                    blend: 'dest-in'
                }])
                .png()
                .toBuffer();

            // Generate output key
            const outputKey = key
                .replace('uploads/', 'processed/')
                .replace(/\.[^.]+$/, '_circular.png');

            // Upload processed image
            await s3Client.send(new PutObjectCommand({
                Bucket: bucket,
                Key: outputKey,
                Body: circleBuffer,
                ContentType: 'image/png',
                Metadata: {
                    'original-key': key,
                    'processed-timestamp': new Date().toISOString()
                }
            }));

            console.log(`Processed: ${outputKey}`);
            results.push({ success: true, key: outputKey });

        } catch (error) {
            console.error('Processing error:', error);
            results.push({ success: false, error: error.message });
        }
    }

    return {
        statusCode: 200,
        body: JSON.stringify({ results })
    };
};

async function streamToBuffer(stream) {
    const chunks = [];
    for await (const chunk of stream) {
        chunks.push(chunk);
    }
    return Buffer.concat(chunks);
}