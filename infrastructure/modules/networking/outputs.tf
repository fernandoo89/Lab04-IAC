output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "public_subnet_a_id" {
  value = aws_subnet.public_a.id
}

output "public_subnet_b_id" {
  value = aws_subnet.public_b.id
}

output "private_subnet_a_id" {
  value = aws_subnet.private_a.id
}

output "private_subnet_b_id" {
  value = aws_subnet.private_b.id
}

output "lambda_upload_sg_id" {
  value = aws_security_group.lambda_upload.id
}

output "lambda_crop_sg_id" {
  value = aws_security_group.lambda_crop.id
}

output "nat_gateway_a_id" {
  value = aws_nat_gateway.nat_a.id
}

output "nat_gateway_b_id" {
  value = var.enable_nat_ha ? aws_nat_gateway.nat_b[0].id : null
}

output "s3_endpoint_id" {
  value = aws_vpc_endpoint.s3.id
}

output "sqs_endpoint_id" {
  value = aws_vpc_endpoint.sqs.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.main.id
}
