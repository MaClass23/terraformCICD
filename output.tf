output "ec2_global_ips_ubuntu" {
  value = ["${aws_instance.ubuntu.*.public_ip}"]
}

output "ec2_global_ips_RedHat" {
  value = ["${aws_instance.RedHat.*.public_ip}"]
}
