resource "aws_cloudwatch_event_rule" "lambda_trigger" {
  name        = "eventrule"
  description = "Trigger Lambda every 1 minute"

  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.lambda_trigger.name
  target_id = "InvokeLambdaFunction"
  arn = "arn:aws:lambda:us-east-1:446611234961:function:lambdafunction"
}

resource  "aws_lambda_permission" "test" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = "lambdafunction"
  principal     = "events.amazonaws.com"
  source_arn    = "arn:aws:lambda:us-east-1:446611234961:function:lambdafunction"
}
