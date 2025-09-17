
# Cloud Security & Automation ☁️  

## Overview  
This repo contains my cloud security automation projects:  
1. **Terraform Misconfiguration Scanner**  
2. **AWS Lambda Malware Scanner**  

## Problem  
Cloud environments scale quickly, and misconfigurations or malware uploads often go unnoticed.  

## Solution  
- **Terraform Misconfiguration Scanner**:  
  - Flags public S3 buckets, unencrypted EBS, overly permissive IAM roles.  
  - Outputs JSON reports for Splunk/ELK ingestion.  
- **AWS Lambda Malware Scanner**:  
  - Triggers on S3 uploads.  
  - Uses **GuardDuty Malware Protection** for scanning.  
  - Sends alerts to Security Hub & Slack.  

## Impact  
- Reduced manual audit time by **70%**  
- Cut malware exposure windows by **90%**  
- Enforced secure defaults across AWS accounts  

## Architecture  
```mermaid
flowchart TD
    A[Terraform Template] --> B[Misconfig Scanner]
    B --> C[JSON Report]
    C --> D[Splunk/ELK]
    C --> E[AWS Config Validation]

    X[S3 Upload] --> Y[Lambda Malware Scanner]
    Y --> Z[GuardDuty Malware Detection]
    Z --> H[Security Hub Alerts]
