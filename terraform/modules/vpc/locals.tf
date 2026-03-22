locals {
  public_subnet_one_cidr_block  = cidrsubnet(aws_vpc.main.cidr_block, 4, 0)
  public_subnet_two_cidr_block  = cidrsubnet(aws_vpc.main.cidr_block, 4, 1)
  private_subnet_one_cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, 2)
  private_subnet_two_cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, 3)
}