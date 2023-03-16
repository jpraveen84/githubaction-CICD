output "roleARN" {
    value = aws_iam_role.ecsTaskExecutionRole-demo.arn
}

output "ecrRoleARN" {
   value =  aws_iam_role.ecrImagePolicy.arn
}