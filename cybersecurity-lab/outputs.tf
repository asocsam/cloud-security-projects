output "attacker_public_ip" {
  description = "Public IP of the attacker VM"
  value       = aws_instance.attacker.public_ip
}

output "attacker_private_ip" {
  description = "Private IP of the attacker VM"
  value       = aws_instance.attacker.private_ip
}

output "dvwa_private_ip" {
  description = "Private IP of the DVWA host"
  value       = aws_instance.dvwa.private_ip
}

output "windows_private_ip" {
  description = "Private IP of the Windows victim"
  value       = aws_instance.windows.private_ip
}

output "siem_private_ip" {
  description = "Private IP of the SIEM host"
  value       = try(aws_instance.siem[0].private_ip, null)
}
