terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.5"
    }
  }
  required_version = ">= 1.8"
  #### enable remote TF state
  backend "s3" {
    bucket = "terraform-state-s3-sergei"   # please use your bucket name!!!
    key    = "aws-lambda/tf-state.tfstate" # Path to the state file in the bucket
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_s3_policy" {
  name = "lambda_s3_policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket"
      ],
      Resource = [
        "arn:aws:s3:::terraform-state-s3-sergei",
        "arn:aws:s3:::terraform-state-s3-sergei/*"
      ]
    }]
  })
}

resource "aws_lambda_function" "lambda_func" {
  function_name = "MyLambdaFunction"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.9"
  timeout       = 10

  # Файл zip должен содержать:
  # - main.py
  # - зависимости из requirements.txt
  filename         = "${path.module}/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda.zip")
}
