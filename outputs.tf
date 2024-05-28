output "ssh-command" {
  value = "ssh -i ${var.ami_key_pair_name}.pem ec2-user@${aws_instance.jenkins_host.public_ip}"
  description = "SSH command to connect to the EC2 instance"
}

output "app-subnet-id" {
  value = aws_subnet.app-subnet.id
  description = "The id of the App subnet."
}

output "test-env-vpc-id" {
  value = aws_vpc.test-env.id
  description = "The id of the test-env vpc."
}