# Terraform Misconfiguration Scanner

Static analysis utility for Terraform templates that flags risky defaults before they reach production.

## Detection Coverage
- Publicly accessible S3 buckets without encryption.
- Unencrypted EBS volumes or snapshots.
- IAM roles/policies with wildcard (`*`) permissions.
- Security groups exposing sensitive ports to the internet.

## How It Works
1. Parses Terraform configuration to build a resource graph.
2. Evaluates each resource against policy-as-code rules.
3. Outputs JSON/CSV reports that can be ingested by Splunk, ELK, or custom dashboards.

## Usage
```bash
pip install -r requirements.txt
terraform plan -out tfplan.binary
python scan.py --plan tfplan.binary --format json --output report.json
```

## Roadmap Enhancements
- Add custom policy authoring with Rego (OPA) to extend coverage.
- Integrate with GitHub Actions for pull-request gating.
- Export results to AWS Security Hub for continuous compliance.
