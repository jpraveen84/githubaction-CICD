resource "aws_iam_policy" "ecsTaskExecutionPolicy" {
  name        = "ecs-task-execution-policy"
  path        = "/"
  policy      = file("files/ecs-task-execution-policy.json")
}


resource "aws_iam_policy" "ecrPolicy" {
  name        = "ecr-policy"
  path        = "/"
  policy      = file("files/ecr-policy.json")
}
