data "aws_ssm_parameter" "nfs_server_ip" {
  provider = aws.parameters
  name     = "/nfs/ipv4"
}