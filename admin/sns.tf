module "sns_topic" {
  source  = "terraform-aws-modules/sns/aws"
  version = "~> 3.0"

  name  = "my-topic"
}

locals {
  emails = [var.my_email]
}

resource "aws_sns_topic_subscription" "topic_email_subscription" {
  count     = length(local.emails)
//  topic_arn = aws_sns_topic.topic.arn
  topic_arn = module.sns_topic.sns_topic_arn
  protocol  = "email"
  endpoint  = local.emails[count.index]
}
//
//resource "aws_cloudwatch_metric_alarm" "ec2_cpu" {
//  alarm_name                = "cpu-utilization"
//  comparison_operator       = "GreaterThanOrEqualToThreshold"
//  evaluation_periods        = "1"
//  metric_name               = "CPUUtilization"
//  namespace                 = "AWS/EC2"
//  period                    = "120" #seconds
//  statistic                 = "Average"
//  threshold                 = "30"
//  alarm_description         = "This metric monitors ec2 cpu utilization"
//  insufficient_data_actions = []
//
//  actions_enabled     = "true"
//  alarm_actions       = [module.sns_topic.sns_topic_arn]
//  dimensions = {
//    InstanceId = "i-0dadbadc0ce8602e1"
//  }
//}

