
resource "aws_iam_role" "ecsTaskExecutionRole-demo" {
  name                = "ecsTaskExecutionRole-demo"
  #assume_role_policy  = "{\"Version\":\"2008-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"ecs-tasks.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
  assume_role_policy = file("files/sts-assume-role.json")
}



resource "aws_iam_policy_attachment" "attachPolicy" {
  name = "ecsRoleAttachment"
  roles      = [aws_iam_role.ecsTaskExecutionRole-demo.name]
  policy_arn = aws_iam_policy.ecsTaskExecutionPolicy.arn

}


resource "aws_iam_role" "ecrImagePolicy" {
  name                = "ecrImagePolicy"
  #assume_role_policy  = "{\"Version\":\"2008-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"ecs-tasks.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
  assume_role_policy = file("files/ecr-sts-assume-role-git.json")
}

resource "aws_iam_policy_attachment" "attachPolicyECR" {
  name = "ecsRoleAttachment"
  roles      = [aws_iam_role.ecrImagePolicy.name]
  policy_arn = aws_iam_policy.ecrPolicy.arn

}