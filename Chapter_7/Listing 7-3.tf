variable "aws-account-id" {
  default = "168181944806"
}

variable "aws-region" {
  default = "us-east-1"
}

variable "repository_name" {
  default = "target-codeommit-repository"
}

variable "sns-topic-prefix" {
  default = "codecommit-"
}

variable "sns-topic-suffix" {
  default = "-topic"
}

provider "aws" {
  region = "${var.aws-region}"
  alias = "default"
}

data "aws_iam_policy_document" "sns-sqs-policy" {
  policy_id = "arn:aws:sqs:us-east-1:${var.aws-account-id}:testing/SQSDefaultPolicy"
  statement {
    sid = "SubscribeToSNS"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [ "*" ]
    }
    actions = [ "SQS:SendMessage" ]
    resources = [ "${aws_sqs_queue.main.arn}" ]
    condition {
      test = "ArnLike"
      variable = "aws:SourceArn"
      values = [ "arn:aws:sns:${var.aws-region}:${var.aws-account-id}:${var.sns-topic-prefix}*${var.sns-topic-suffix}" ]
    }
  }
}

data "aws_iam_policy_document" "sns-policy" {
  policy_id = "__default_policy_ID"
  statement {
    sid = "AllowSubscriptionFromSQS"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [ "*" ]
    }
    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
      "SNS:Receive"
    ]
    resources = [ "${aws_sns_topic.main.arn}" ]
    condition {
      test = "StringEquals"
      variable = "AWS:SourceOwner"
      values = [ "${var.aws-account-id}" ]
    }
  }
}

resource "aws_sqs_queue" "main" {
  name = "codecommit-notifications-queue"
  delay_seconds = 90
  max_message_size = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
}

resource "aws_sqs_queue_policy" "sns" {
  queue_url = "${aws_sqs_queue.main.id}"
  policy = "${data.aws_iam_policy_document.sns-sqs-policy.json}"
}


resource "aws_codecommit_trigger" "main" {
  repository_name = "${var.repository_name}"

  trigger {
    name = "notifications"
    events = ["all"]
    destination_arn = "${aws_sns_topic.main.arn}"
  }
}

resource "aws_sns_topic" "main" {
  name = "${var.sns-topic-prefix}${var.repository_name}${var.sns-topic-suffix}"
  display_name = "CodeCommit ${var.repository_name} notifications"
}

resource "aws_sns_topic_policy" "main" {
  arn = "${aws_sns_topic.main.arn}"
  policy = "${data.aws_iam_policy_document.sns-policy.json}"
}

resource "aws_sns_topic_subscription" "sqs" {
  topic_arn = "${aws_sns_topic.main.arn}"
  endpoint = "${aws_sqs_queue.main.arn}"
  raw_message_delivery = "true"
  protocol = "sqs"
}

output "sns-name" {
  value = "${aws_sns_topic.main.name}"
}

output "sns-arn" {
  value = "${aws_sns_topic.main.arn}"
}