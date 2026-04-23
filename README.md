# 🛡️ AWS WAF Project – Sensitive Path Protection  
**Protecting Web Applications by Blocking High-Risk URL Patterns**

---

## 🌐 Overview  

This project implements AWS WAF rules to protect web applications by **blocking HTTP requests that target sensitive URL paths** such as `/password`, `/creditcard`, and other credential-related endpoints.

The goal is simple: **reduce exposure to common web attacks** including credential harvesting, automated scanning, and reconnaissance activity—before traffic reaches the application layer.

---

## 🎯 Objectives  

- Prevent unauthorized access attempts targeting sensitive endpoints  
- Reduce the attack surface of internet-facing applications  
- Enforce consistent edge-layer security across ALB and CloudFront  
- Support compliance with **OWASP Top 10** and **PCI-DSS**  

---

## 🏗️ Architecture  

Client → AWS WAF → ALB / CloudFront → Application  

- AWS WAF inspects incoming requests at the edge  
- Requests matching sensitive patterns are **blocked immediately**  
- Legitimate traffic is forwarded to backend services  
- Logging captures activity for monitoring and analysis  

---

## 🔐 Key Components  

- **AWS WAF Web ACL** – Central rule enforcement  
- **Custom Rules** – Pattern-based detection of sensitive paths  
- **ALB / CloudFront Integration** – Edge-level protection  
- **WAF Logging** – Visibility into blocked and allowed traffic  

---

## 📁 Repository Structure  
├── aws/
├── create_sensitive_waf.sh
├── waf-rules.json
├── waf-logging-policy.json
└── README.md


---

## 📄 Key Files  

### `waf-rules.json`  
Defines custom WAF rules to block requests targeting sensitive paths.

### `create_sensitive_waf.sh`  
Automates creation and deployment of the WAF Web ACL and rules.

### `waf-logging-policy.json`  
Enables logging for monitoring, auditing, and tuning.

---

## ⚙️ Example Rule Logic  

The WAF rules inspect incoming requests and block traffic when URL paths match patterns such as:

- `/password`  
- `/creditcard`  
- `/credentials`  
- `/secret`  

This helps prevent attackers from probing authentication, payment, or sensitive data endpoints.

---

## 🚀 Deployment  

### Prerequisites  
- AWS account  
- AWS CLI configured  
- IAM permissions for WAF, ALB, and CloudFront  

### Steps  

1. Customize sensitive patterns in `waf-rules.json`  

2. Run the deployment script:  
```bash
./create_sensitive_waf.sh

Attach the Web ACL to:
Application Load Balancer
CloudFront distribution
Enable logging for monitoring and analysis

📊 Security Impact

Blocks requests targeting high-risk endpoints
Reduces exposure to credential harvesting and scanning attacks
Enforces consistent edge-layer protection
Improves visibility through centralized WAF logging

🔒 Security Considerations

Rules are designed to fail closed (block suspicious traffic)
Logging supports detection of false positives and rule tuning
Patterns can be extended for organization-specific use cases
Complements application-layer security—not a replacement

📌 Use Cases

Protecting login and authentication endpoints
Securing payment and checkout flows
Reducing automated scanning and brute-force attempts
Standardizing edge security across microservices

🚀 Future Enhancements

Integrate AWS Managed Rule Groups
Add rate-based rules for brute-force protection
Export WAF logs to SIEM or analytics pipelines
Convert rules into Terraform for multi-account deployment

🧾 Summary

This project demonstrates how to use AWS WAF to enforce proactive, edge-level security controls that block malicious traffic before it reaches backend services.

It provides a practical example of applying cloud security and defense-in-depth principles in real-world environments.

👤 Author

Taiwo Justice Olorunlana
Cloud Security | DevSecOps | Infrastructure Automation
