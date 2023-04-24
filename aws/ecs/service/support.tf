resource aws_cloudwatch_log_group default {
  name = "${var.name}-default"
  tags = var.tags
}

resource aws_cloudwatch_log_group target {
  name = var.name
  tags = var.tags
}

resource aws_ecr_repository default {
  count = local.enable_ecr ? 1 : 0
  name  = var.name
  tags  = var.tags
}

locals {
  cluster_patch_parts  = split("/", var.cluster)
  cluster_patch_length = length(local.cluster_patch_parts)
  cluster_patch_name   = local.cluster_patch_parts[local.cluster_patch_length - 1]
}

data aws_ecs_cluster default {
  // patched to replace arn with name
  cluster_name = local.cluster_patch_name
}

data local_file flask-service {
  filename = "${path.module}/python/flask-service.py"
}

locals {
  enable_ecr  = ! contains(keys(var.task_config), "image")
  image       = local.enable_ecr ? aws_ecr_repository.default[0].repository_url : var.task_config["image"]
  ports       = lookup(var.task_config, "ports", [])
  target_port = length(local.ports) > 0 ? local.ports[0] : null
}

locals {
  default_command = trimspace(replace(data.local_file.flask-service.content, "/\n|\r\n/", ";"))
  default_envs = {
    service-name = var.name
    service-port = local.target_port
  }
}

locals {
  load_balancer_1 = var.target_group != null ? [{ target_group_arn = var.target_group }] : []
  load_balancers  = concat(local.load_balancer_1, var.load_balancer)
}

locals {
  capacity_providers = [
    for item in var.capacity_providers :
    merge(item, { name = replace(upper(item["name"]), "-", "_") })
    if contains(keys(item), "name")
  ]
}