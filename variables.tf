variable "region" {
  description = "The AWS region to deploy the Lambda function."
  type        = string
  default     = "eu-west-1" 
}

variable "lambda_function_name" {
  description = "The name of the Lambda function."
  type        = string
  default     = "lambda-autoreminder"
}

variable "script_path" {
  description = "The path to the Python script to deploy."
  type        = string
  default = "./python/autoreminder.py"
}

variable "sender_email" {
  description = "The sender email address for the reminder emails."
  type        = string
  default    = "mail@gika.dev"
}