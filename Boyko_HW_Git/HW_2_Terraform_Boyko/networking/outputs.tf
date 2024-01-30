output "private_subnet_id" {
  value = aws_subnet.edu_subnet_private.id
}

output "public_subnet_id" {
  value = aws_subnet.edu_subnet_public.id
}

