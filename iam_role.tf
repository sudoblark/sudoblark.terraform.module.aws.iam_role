resource "aws_iam_role" "roles" {
  for_each = { for role in var.raw_iam_roles : role.suffix => role }

  name               = format(lower("aws-${var.environment}-${var.application_name}-%s-role"), each.value["suffix"])
  assume_role_policy = data.aws_iam_policy_document.assume_policies[each.value["suffix"]].json

  managed_policy_arns = [aws_iam_policy.policy[each.value["suffix"]].arn]

  depends_on = [
    aws_iam_policy.policy
  ]
}