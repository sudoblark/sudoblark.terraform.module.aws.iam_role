data "aws_iam_policy_document" "attached_policies" {
  for_each = { for role in var.raw_iam_roles : role.suffix => role }

  dynamic "statement" {
    for_each = each.value["iam_policy_statements"]

    content {
      sid       = statement.value["sid"]
      actions   = statement.value["actions"]
      resources = statement.value["resources"]

      dynamic "condition" {
        for_each = statement.value["conditions"]

        content {
          test     = condition.value["test"]
          variable = condition.value["variable"]
          values   = condition.value["values"]
        }
      }
    }
  }
}

data "aws_iam_policy_document" "assume_policies" {
  for_each = { for role in var.raw_iam_roles : role.suffix => role }

  dynamic "statement" {
    for_each = length(each.value["assume_policy_principles"]) > 0 ? each.value["assume_policy_principles"] : []

    content {
      actions = ["sts:AssumeRole"]
      principals {
        type        = statement.value["type"]
        identifiers = statement.value["identifiers"]
      }

      dynamic "condition" {
        for_each = statement.value["conditions"]

        content {
          test     = condition.value["test"]
          variable = condition.value["variable"]
          values   = condition.value["values"]
        }
      }
    }
  }
}

