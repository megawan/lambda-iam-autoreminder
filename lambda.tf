# Create an IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name               = var.lambda_function_name 
  assume_role_policy = data.aws_iam_policy_document.lambda_policy.json
}

# Attach the IAM policy to the role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Define the IAM policy for the Lambda function
resource "aws_iam_policy" "lambda_policy" {
  name   = var.lambda_function_name + "_policy"  
  policy = data.aws_iam_policy_document.lambda_policy.json
}

# Create the Lambda function
resource "aws_lambda_function" "access_key_reminder_lambda" {
  function_name = var.lambda_function_name 
  filename      = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"  
  role          = aws_iam_role.lambda_role.arn
  environment {
    variables = {
      SENDER_EMAIL = var.sender_email  
    }
  }
}
