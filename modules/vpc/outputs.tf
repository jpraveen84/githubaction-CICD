output "publicsubnet" {

     value        = tolist(data.aws_subnet_ids.public.ids)

}

output "sgID" {
      value        = aws_security_group.access_for_port_80[0].id
}


output "vpcID" {
    value  = aws_vpc.pear_vpc.id
}

output "ecsSG" {
    value = aws_security_group.ecs_80[0].id
}