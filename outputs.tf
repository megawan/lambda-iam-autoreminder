output "lambda_function_arn" {
  description = "The ARN of the deployed Lambda function."
  value       = aws_lambda_function.access_key_reminder_lambda.arn
}

output "lambda_function_invoke_arn" {
  description = "The ARN to use for invoking the Lambda function."
  value       = aws_lambda_function.access_key_reminder_lambda.invoke_arn
}