# Cybersecurity Lab Terraform

This Terraform configuration builds a small virtual private cloud (VPC) that mirrors the reference architecture from the lab diagrams. It provisions an attacker workstation in a public subnet and places the vulnerable (DVWA), Windows victim, and optional SIEM hosts inside a private subnet that is only reachable through tightly-controlled security group rules.

## Components

- **VPC & Subnets** – Single VPC with one public subnet (attacker) and one private subnet (victim workloads).
- **Internet Gateway** – Allows inbound SSH access to the attacker VM.
- **Security Groups** – Follows the connectivity shown in the diagrams:
  - `attacker_sg` exposes SSH and allows egress to the private subnet.
  - `dvwa_sg` only permits inbound HTTP/8888 traffic sourced from the attacker security group.
  - `windows_victim_sg` opens RDP and syslog ports for the attacker workstation.
  - `siem_sg` accepts log ingestion traffic (TCP/9997) from the Windows host.
- **EC2 Instances** – Four EC2 instances that represent the attacker (Ubuntu), DVWA Metasploitable host, Windows victim machine, and an optional SIEM box.

## Usage

1. Export AWS credentials (`AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`).
2. Update `terraform.tfvars` with AMI IDs and key pair names that exist in your account/region.
3. Initialise and apply:

```bash
terraform init
terraform apply
```

The outputs will display the public IP for the attacker VM and the private IP addresses for the internal hosts. Use these when configuring your lab tooling.

## Cleanup

Destroy the lab when you are finished to avoid costs:

```bash
terraform destroy
```

## Enhancements

- Replace the Windows EC2 instance with an Amazon WorkSpaces desktop for a managed experience.
- Add AWS Systems Manager Session Manager to remove the need for direct SSH/RDP exposure.
- Pipe the SIEM security group traffic into Amazon OpenSearch or Splunk for persistent log storage.
