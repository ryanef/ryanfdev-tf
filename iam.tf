# https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services

# data "aws_iam_openid_connect_provider" "example" {
#   url = "https://token.actions.githubusercontent.com"

# }

resource "aws_iam_openid_connect_provider" "default" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = ["cf23df2207d99a74fbe169e3eba035e633b65d94"]
}

resource "aws_iam_policy" "githubrole" {
  name   = "ghactionsrole"
  policy = data.aws_iam_policy_document.github.json
}

resource "aws_iam_role" "ghactions" {
  name               = "ghactions"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_policy_attachment" "attach" {
  name       = "attachment"

  roles      = [aws_iam_role.ghactions.id]

  policy_arn = aws_iam_policy.githubrole.arn
}