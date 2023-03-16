
data "aws_availability_zones" "available" {}

resource "aws_vpc" "pear_vpc" {
    cidr_block = var.vpc_cidr
    tags = local.tags
}

resource "aws_subnet" "public-subnet" {

    count = length(data.aws_availability_zones.available.names)
    vpc_id = aws_vpc.pear_vpc.id
    cidr_block = "10.0.${16*count.index}.0/20"
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true
    tags = merge(local.tags,
    {
      Type = "publicSubnet"
    }
  )
}



resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.pear_vpc.id
    tags = {
       Name = "tf-igw"
  }
}

resource "aws_route_table" "public" {

    vpc_id = aws_vpc.pear_vpc.id

    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
    tags = {
       Name = "public-rt"
  }
}
resource "aws_eip" "nat" {
   vpc = true
}
data "aws_subnet_ids" "public" {
    vpc_id = aws_vpc.pear_vpc.id
    depends_on = [aws_subnet.public-subnet]
    tags = {
     Type = "publicSubnet"
  }
}


resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat.id
    subnet_id     = tolist(data.aws_subnet_ids.public.ids)[0]
    tags          = {
        Name      = "nat-gw"
    }
}

resource "aws_route_table" "Private" {

    vpc_id        = aws_vpc.pear_vpc.id

    route  {
      cidr_block  = "0.0.0.0/0"
      gateway_id  = aws_nat_gateway.nat.id
    }
    tags = {
       Name       = "private-rt"
  }
  
}


resource "aws_route_table_association" "publicsubnet" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = tolist(data.aws_subnet_ids.public.ids)[count.index]
  route_table_id = aws_route_table.public.id
}

output "AZ-1" {

      value       = data.aws_availability_zones.available
  
}

# output "publicsubnet-1" {

#      value        = tolist(data.aws_subnet_ids.public.ids)

# }