output "instance" {
  value     = aws_instance.mtc-node[*]
  sensitive = true
}
