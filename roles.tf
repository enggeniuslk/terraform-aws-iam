locals {
  role_to_base_path = {
    for k in fileset("${abspath(local.roles_path)}", "**/assume_role.json") : dirname(k) => dirname(abspath("${local.roles_path}/${k}"))
  }
  role_to_attachments = {
    for k, v in local.role_to_base_path : k => try(yamldecode(file("${v}/attachments.yml"))["policy_arns"], [])
  }
  _role_policies = distinct(flatten(
    [
      for role, attachments_list in local.role_to_attachments : [
        for attachment in attachments_list : {
          role       = role
          attachment = attachment

        }
      ]
    ]
  ))
  role_policies = {
    for role_policy in local._role_policies : "${role_policy.role}.${role_policy.attachment}" => role_policy
  }


}

resource "aws_iam_role" "roles" {
  for_each = local.role_to_base_path

  name               = each.key
  assume_role_policy = file("${each.value}/assume_role.json")
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  for_each   = local.role_policies
  role       = aws_iam_role.roles[each.value.role].name
  policy_arn = each.value.attachment
}

output "role_arns" {
  value = {
    for name, policy_obj in aws_iam_role.roles : name => policy_obj.arn
  }
}