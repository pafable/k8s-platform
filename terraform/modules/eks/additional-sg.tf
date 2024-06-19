# creates a security group that allows all ingress traffic.
# This will be attached to the main-nodes node group.
resource "aws_security_group" "allow_all_ingress_sg" {
  name        = "allow-all-ingress-sg"
  description = "Allow all ingress traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow all ingress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${local.cluster_name}-allow-all-ingress-sg" }
}