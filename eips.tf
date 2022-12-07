resource "aws_eip" "nat-gate-eip" {
  # EIP may require IGW to exist prior to association.
  # Use depends_on to set an explicit dependency on the IGW.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "nat-gate" {
  allocation_id = aws_eip.nat-gate-eip.id # for the gateway
  # The subnet ID of the subnet in which to place the gateway.connection 
  subnet_id = aws_subnet.eks-public1.id
}

