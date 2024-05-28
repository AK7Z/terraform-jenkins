### Policies ###

resource "aws_iam_policy" "jenkins_s3_bucket_policy" {
  name        = "EC2JenkinsFileBucket"
  description = "Access bucket containing files for Jenkins"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObject"]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.jenkins_files.arn}/*"
      }
    ]
  })
}

resource "aws_iam_policy" "terraform_ec2_policy" {
  name        = "TerraformEC2FullAccess"
  description = "Full access to EC2 for Terraform"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ec2:*"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "terraform_state_policy" {
  name        = "TerraformEC2StateAccess"
  description = "Access to the terraform state file"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [
          var.jenkins_tf_state_bucket_arn,
          "${var.jenkins_tf_state_bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "terraform_dynamodb_policy" {
  name        = "TerraformDynamoDBFullAccess"
  description = "Access DynamoDB for Terraform state file"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:dynamodb:eu-west-1:${local.account_id}:table/${var.project_name}-terraform-state-lock-table"
      }
    ]
  })
}

### Terraform Role ###

resource "aws_iam_role" "terraform_role" {
  name = "JenkinsTerraformRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

### Attach Policies to Terraform Role ###

resource "aws_iam_role_policy_attachment" "jenkins_s3_bucket_policy" {
  role       = aws_iam_role.terraform_role.name
  policy_arn = aws_iam_policy.jenkins_s3_bucket_policy.arn
}

resource "aws_iam_role_policy_attachment" "terraform_ec2_policy" {
  role       = aws_iam_role.terraform_role.name
  policy_arn = aws_iam_policy.terraform_ec2_policy.arn
}

resource "aws_iam_role_policy_attachment" "terraform_state_policy" {
  role       = aws_iam_role.terraform_role.name
  policy_arn = aws_iam_policy.terraform_state_policy.arn
}

resource "aws_iam_role_policy_attachment" "terraform_dynamodb_policy" {
  role       = aws_iam_role.terraform_role.name
  policy_arn = aws_iam_policy.terraform_dynamodb_policy.arn
}

### EC2 Instance Profile ###

resource "aws_iam_instance_profile" "jenkins_terraform_instance_profile" {
  name = "JenkinsTerraformInstanceProfile"
  role = aws_iam_role.terraform_role.name
}