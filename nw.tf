#creating VPC for ECS cluster

data "aws_availability_zones" "available" {

}

resource "aws_vpc" "ecs-vpc" {
  cidr_block = var.aws_vpc_cidr
}


resource "aws_subnet" "ecs-subnet" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.ecs-vpc.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.ecs-vpc.id
  
}

resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.ecs-vpc.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.ecs-vpc.id
  
  map_public_ip_on_launch = false
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.ecs-vpc.id
}

# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.ecs-vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}
