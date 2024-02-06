data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = var.script_path  
  output_path = "lambda_function.zip"
}

# Define the IAM policy document for the Lambda function
data "aws_iam_policy_document" "lambda_policy" {
  statement {
    actions = [
      "iam:ListUsers",
      "iam:ListUserTags",
      "iam:ListAccessKeys",
      "ses:SendEmail",
    ]
    resources = ["*"]
  }
}