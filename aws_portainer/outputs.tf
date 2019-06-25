locals {
  instance_id                           = compact(coalescelist(aws_instance.instance.*.id, [""]))
  instance_availability_zone            = compact(coalescelist(aws_instance.instance.*.availability_zone, [""]))
  instance_key_name                     = compact(coalescelist(aws_instance.instance.*.key_name, [""]))
  instance_public_dns                   = compact(coalescelist(aws_instance.instance.*.public_dns, [""]))
  instance_public_ip                    = compact(coalescelist(aws_instance.instance.*.public_ip, [""]))
  instance_primary_network_interface_id = compact(coalescelist(aws_instance.instance.*.primary_network_interface_id, [""]))
  instance_private_dns                  = compact(coalescelist(aws_instance.instance.*.private_dns, [""]))
  instance_private_ip                   = compact(coalescelist(aws_instance.instance.*.private_ip, [""]))
  instance_placement_group              = compact(concat(coalescelist(aws_instance.instance.*.placement_group, [""])))
  instance_security_groups              = coalescelist(aws_instance.instance.*.security_groups, [""])
  instance_vpc_security_group_ids       = coalescelist(flatten(aws_instance.instance.*.vpc_security_group_ids), [""])
  instance_subnet_id                    = compact(coalescelist(aws_instance.instance.*.subnet_id, [""]))
  instance_tags                         = coalescelist(aws_instance.instance.*.tags, [""])
  instance_volume_tags                  = coalescelist(aws_instance.instance.*.volume_tags, [""])
  instance_password_data                = coalescelist(aws_instance.instance.*.password_data, [""])
}

output "id" {
  description = "List of IDs of instances"
  value       = local.instance_id
}

output "availability_zone" {
  description = "List of availability zones of instances"
  value       = local.instance_availability_zone
}

output "placement_group" {
  description = "List of placement groups of instances"
  value       = local.instance_placement_group
}

output "key_name" {
  description = "List of key names of instances"
  value       = local.instance_key_name
}

output "public_dns" {
  description = "List of public DNS names assigned to the instances. For EC2-VPC, instance is only available if you've enabled DNS hostnames for your VPC"
  value       = local.instance_public_dns
}

output "public_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = local.instance_public_ip
}

output "primary_network_interface_id" {
  description = "List of IDs of the primary network interface of instances"
  value       = local.instance_primary_network_interface_id
}

output "private_dns" {
  description = "List of private DNS names assigned to the instances. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value       = local.instance_private_dns
}

output "private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = local.instance_private_ip
}

output "password_data" {
  description = "List of Base-64 encoded encrypted password data for the instance"
  value       = local.instance_password_data
}

output "security_groups" {
  description = "List of associated security groups of instances"
  value       = local.instance_security_groups
}

output "vpc_security_group_ids" {
  description = "List of associated security groups of instances, if running in non-default VPC"
  value       = local.instance_vpc_security_group_ids
}

output "subnet_id" {
  description = "List of IDs of VPC subnets of instances"
  value       = local.instance_subnet_id
}


output "tags" {
  description = "List of tags of instances"
  value       = local.instance_tags
}

output "volume_tags" {
  description = "List of tags of volumes of instances"
  value       = local.instance_volume_tags
}

