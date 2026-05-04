output "upload_lambda_role_arn" {
  value = aws_iam_role.upload_lambda_role.arn
}

output "upload_lambda_role_name" {
  value = aws_iam_role.upload_lambda_role.name
}

output "crop_lambda_role_arn" {
  value = aws_iam_role.crop_lambda_role.arn
}

output "crop_lambda_role_name" {
  value = aws_iam_role.crop_lambda_role.name
}
