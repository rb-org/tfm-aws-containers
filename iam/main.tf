resource "aws_iam_role" "ecs_role" {
  name = "${local.ecs_role_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  tags = "${merge(
    var.default_tags, 
    map(
      "Name", "${local.ecs_role_name}",
      "Workspace", "${terraform.workspace}"
    )
  )}"
}

resource "aws_iam_instance_profile" "ecs_role_instance_profile" {
  name = "${local.ecs_role_name}-profile"
  role = "${aws_iam_role.ecs_role.name}"
}

resource "aws_iam_policy" "ecr_access" {
  name        = "${local.ecr_access_policy_name}"
  description = "ECR Access Policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecr_access" {
  role       = "${aws_iam_role.ecs_role.name}"
  policy_arn = "${aws_iam_policy.ecr_access.arn}"
}

resource "aws_iam_role_policy_attachment" "managed_policies" {
  count      = "${length(local.policy_arns)}"
  role       = "${aws_iam_role.ecs_role.name}"
  policy_arn = "${local.policy_arns[count.index]}"
}
