Write-Host "🔨 Building Lambda functions..." -ForegroundColor Green

# Build upload-lambda
Write-Host " Building upload-lambda..." -ForegroundColor Cyan
Set-Location upload
npm install --production
Compress-Archive -Path * -DestinationPath ..\upload-lambda.zip -Force
Set-Location ..

# Build crop-lambda
Write-Host "Building crop-lambda..." -ForegroundColor Cyan
Set-Location crop
npm install --production
Compress-Archive -Path * -DestinationPath ..\crop-lambda.zip -Force
Set-Location ..

Write-Host " Build complete!" -ForegroundColor Green
Write-Host "   - upload-lambda.zip"
Write-Host "   - crop-lambda.zip"