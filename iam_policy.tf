resource "aws_iam_policy" "policy" {
  for_each = { for role in var.raw_iam_roles : role.suffix => role }

  name   = format(lower("aws-${var.environment}-${var.application_name}-%s-policy"), each.value["suffix"])
  path   = each.value["path"]
  policy = data.aws_iam_policy_document.attached_policies[each.value["suffix"]].json

  depends_on = [
    data.aws_iam_policy_document.attached_policies
  ]
}