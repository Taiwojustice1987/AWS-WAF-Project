# AWS WAF Project – Sensitive Path Protection

## Overview
This project implements **AWS WAF rules** to protect global and regional web resources by blocking HTTP requests that target **sensitive URL paths**, such as those containing keywords like `password`, `creditcard`, or other credential-related patterns.

The goal is to reduce exposure to **OWASP-class attacks**, credential harvesting attempts, and reconnaissance activity targeting authentication and payment-related endpoints.

---

## Security Objectives
- Prevent unauthorized access attempts targeting sensitive application paths  
- Reduce attack surface for internet-facing applications  
- Enforce consistent edge security across ALB and CloudFront deployments  
- Support compliance and security best practices (OWASP Top 10, PCI-DSS)

---

## Architecture
The solution applies AWS WAF rules at the **edge layer**, protecting traffic before it reaches application services.

### Protected Resources
- Application Load Balancers (ALB)  
- CloudFront distributions (global edge protection)

### Key Components
- AWS WAF Web ACL  
- Custom WAF rules using string and pattern matching  
- Logging and visibility through AWS WAF logging  

---

## Repository Structure
AWS-WAF-Project/
├── aws/
├── create_sensitive_waf.sh
├── waf-rules.json
├── waf-logging-policy.json
├── listener for the ALB
├── application Load Balancer
├── awscilv2.zip
└── README.md

---

## Key Files

### `waf-rules.json`
Defines custom WAF rules to block requests with sensitive URL path patterns.

### `create_sensitive_waf.sh`
Automates creation and deployment of the AWS WAF Web ACL and associated rules.

### `waf-logging-policy.json`
Enables logging for visibility and security monitoring.

### ALB / Listener Files
Associate the WAF Web ACL with application load balancers.

---

## Example Rule Logic
The WAF rules inspect incoming requests and **block traffic when URL paths match sensitive patterns**, including but not limited to:
- `/password`
- `/creditcard`
- `/credentials`
- `/secret`

This prevents attackers from probing or exploiting endpoints related to authentication, payment processing, or sensitive data handling.

---

## Deployment

### Prerequisites
- AWS account  
- AWS CLI configured  
- IAM permissions for WAF, ALB, and logging  

### Steps
1. Review and customize sensitive path patterns in `waf-rules.json`
2. Run the deployment script:
   ```bash
   ./create_sensitive_waf.sh

Attach the Web ACL to:

Application Load Balancer

CloudFront distribution (if applicable)

Enable WAF logging for monitoring and analysis

Security Considerations

Rules are designed to fail closed by blocking suspicious traffic

Logging enables detection of false positives and rule tuning

Patterns can be extended to match organization-specific sensitive endpoints

Designed to complement application-layer security, not replace it

Use Cases

Protecting authentication and login endpoints

Securing payment and checkout flows

Reducing automated scanning and credential-stuffing attempts

Enforcing consistent edge security across microservices

Future Enhancements

Integrate AWS Managed Rule Groups

Add rate-based rules for brute-force protection

Export WAF logs to SIEM or analytics pipelines

Parameterize rules using Terraform for multi-account deployment
