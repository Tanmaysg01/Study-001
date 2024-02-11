resource "aws_secretsmanager_secret" "secret_aws" {
  name = "secretcloud"
}
#aws_policy
data "aws_iam_policy_document" "secret_aws" {
  statement {
    sid    = "EnableAnotherAWSAccountToReadTheSecret"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::123456789012:root"]
    }

    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["*"]
  }
}
#secret manager rotation
 resource "aws_secretsmanager_secret_rotation" "rotation" {
  secret_id           = "arn:aws:secretsmanager:us-east-1:446611234961:secret:secretcloud-1H1BMc"
  rotation_lambda_arn = "arn:aws:lambda:us-east-1:446611234961:function:lambdasecret"

  rotation_rules {
    automatically_after_days = 30
  }
}

resource "aws_lambda_permission" "lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = "lambdasecret"
  principal     = "secretsmanager.amazonaws.com"

}

variable "number" {
  default = {
    key1 = "value1"
    key2 = "value2"
  }

  type = map(string)
}

resource "aws_secretsmanager_secret_version" "secret_aws" {
  secret_id     = "arn:aws:secretsmanager:us-east-1:446611234961:secret:secretcloud-1H1BMc"
  secret_string = jsonencode(var.number)
}

