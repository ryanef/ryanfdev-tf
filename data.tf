data "aws_caller_identity" "current" {}


data "aws_route53_zone" "selected" {
  name         = "${var.your_domain}"
  private_zone = false
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }
      condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
          "sts.amazonaws.com"
      ]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:ryanef/ryanfdev:ref:refs/heads/main"
      ]
    }
  }
  
}

data "aws_iam_policy_document" "github" {
  statement {

    actions = [
      "ssm:GetParameters",

    ]

    effect = "Allow"

    resources = [
      "${aws_ssm_parameter.s3.arn}",
    ]
  }
  statement {

    actions = [
      "cloudfront:CreateInvalidation",

    ]

    effect = "Allow"

    resources = [
      "*",
    ]
  }


  statement {
    actions = [
      "s3:*",
    ]
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${module.s3.s3_origin}",
      "arn:aws:s3:::${module.s3.s3_origin}/*",
    ]
  }
}
