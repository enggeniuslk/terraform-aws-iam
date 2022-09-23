locals {
    policy_to_path = { for k in fileset("${local.policies_path}", "*.json"): split(".json", k)[0] => k }
}

resource "aws_iam_policy" "policy" {
  for_each = local.policy_to_path
  name = each.key
  path = "/"
  description = each.key

  policy = file("${local.policies_path}/${each.value}")
  tags = var.tags
}

output "policy_arns" {
  value = {
    for name, policy_obj in aws_iam_policy.policy: name => policy_obj.arn
  }
}