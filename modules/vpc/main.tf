# ========================
# VPC
# ========================
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, { Name = "${var.name}-vpc" })
}

# ========================
# Internet Gateway
# ========================
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.name}-igw" })
}

# ========================
# Public Subnets
# ========================
resource "aws_subnet" "public" {
  for_each = { for idx, az in tolist(var.azs) : idx => az }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, var.public_subnet_newbits, each.key)
  availability_zone       = each.value
  map_public_ip_on_launch = true

  tags = merge(var.tags, { Name = "${var.name}-public-${each.value}" })
}

# ========================
# Private Subnets
# ========================
resource "aws_subnet" "private" {
  for_each = { for idx, az in tolist(var.azs) : idx => az }

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.private_subnet_newbits, each.key + length(var.azs))
  availability_zone = each.value

  tags = merge(var.tags, { Name = "${var.name}-private-${each.value}" })
}

# ========================
# NAT Gateways + EIPs
# ========================
resource "aws_eip" "nat" {
  for_each = var.enable_ha_nat ? aws_subnet.public : { "0" = values(aws_subnet.public)[0] }

  tags = merge(var.tags, { Name = "${var.name}-nat-eip-${each.value.availability_zone}" })
}

resource "aws_nat_gateway" "this" {
  for_each = var.enable_ha_nat ? aws_subnet.public : { "0" = values(aws_subnet.public)[0] }

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value.id

  tags = merge(var.tags, { Name = "${var.name}-nat-${each.value.availability_zone}" })

  depends_on = [aws_internet_gateway.this]
}

# ========================
# Public Route Table
# ========================
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.name}-public-rt" })
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# ========================
# Private Route Tables
# ========================
resource "aws_route_table" "private" {
  for_each = aws_subnet.private

  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.name}-private-rt-${each.key}" })
}

resource "aws_route" "private_nat_access" {
  for_each = aws_route_table.private

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = (
    var.enable_ha_nat ? aws_nat_gateway.this[each.key].id : values(aws_nat_gateway.this)[0].id
  )
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}
