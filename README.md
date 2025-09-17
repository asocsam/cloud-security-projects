
---

### **Cloud Security Projects** (cloud-security-projects)  
```markdown
# Cloud Security & Automation ☁️  

## Overview  
Cloud-focused security automations including:  
1. **Terraform Misconfiguration Scanner**  
2. **AWS Lambda Malware Scanner**  

## Features  
- Detects open Security Groups, public S3 buckets, unencrypted EBS volumes  
- Lambda + S3 triggers + GuardDuty Malware Protection for auto malware scans  
- AWS Config + Control Tower guardrails  

## Example Run  
```bash
terraform plan
python misconfig_scanner.py
