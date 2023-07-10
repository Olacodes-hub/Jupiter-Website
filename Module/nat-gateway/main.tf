
# create elastic ip for nat gateway az1
resource "aws_eip" "eip_for_nat_gateway_az1" {
  vpc = true

  tags = {
    Name = "eip for nat gateway az1"
  }
}

# create elastic ip for nat gateway az2
resource "aws_eip" "eip_for_nat_gateway_az2" {
  vpc = true

  tags = {
    Name = "eip for nat gateway az1"
  }
}

# create nat gateway for az1
resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.eip_for_nat_gateway_az1.id
  subnet_id     = var.public_subnet_az1_id

  tags = {
    Name = "nat gateway az1"
  }

  depends_on = [var.internet_gateway]

}

# create nat gateway for az2
resource "aws_nat_gateway" "nat_gateway_az2" {
  allocation_id = aws_eip.eip_for_nat_gateway_az2.id
  subnet_id     = var.public_subnet_az2_id

  tags = {
    Name = "nat gateway az2"
  }

  depends_on = [var.internet_gateway]

}


# create private route table az1
resource "aws_route_table" "private_route_table_az1" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_az1.id
  }

  tags = {
    Name = "private route table az1"
  }
}

# create private route table az2
resource "aws_route_table" "private_route_table_az2" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_az2.id
  }

  tags = {
    Name = "private route table az2"
  }
}

# associate route table with private app subnet AZ1
resource "aws_route_table_association" "private_app_subnet_az1" {
  subnet_id      = var.private_app_subnet_az1_id
  route_table_id = aws_route_table.private_route_table_az1.id
}

# associate route table with private data subnet AZ1
resource "aws_route_table_association" "private_data_subnet_az1" {
  subnet_id      = var.private_data_subnet_az1_id
  route_table_id = aws_route_table.private_route_table_az1.id

}

# associate route table with private app subnet AZ2
resource "aws_route_table_association" "private_app_subnet_az2" {
  subnet_id      = var.private_app_subnet_az2_id
  route_table_id = aws_route_table.private_route_table_az2.id
}


# associate route table with private data subnet AZ2
resource "aws_route_table_association" "private_data_subnet_az2" {
  subnet_id      = var.private_data_subnet_az2_id
  route_table_id = aws_route_table.private_route_table_az2.id
}