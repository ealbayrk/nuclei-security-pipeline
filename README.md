Nuclei Security Pipeline

A small DevSecOps lab using Jenkins, Docker, and Nuclei to automate security scanning.

I built this project to practice integrating security checks into a CI/CD pipeline rather than running scans manually.

The target is OWASP Juice Shop, running in a separate Docker container.

Overview

Jenkins and Juice Shop run on the same Docker network. Jenkins executes Nuclei scans against the application and archives the results as JSON artifacts.

Pipeline Stages

Stage	Description
Check Target	Verifies that Juice Shop is reachable.
Technology Detection	Identifies technologies using Nuclei templates.
Misconfiguration Scan	Checks for common security misconfigurations.

Scan reports are archived after each build.

Project Structure

.
├── Dockerfile.jenkins
├── Jenkinsfile
├── scripts/
│   ├── tech-scan.sh
│   ├── misconfig-scan.sh
│   └── run-all.sh
└── README.md

Running Locally

1. Start OWASP Juice Shop

docker run -d --name juice-shop-lab \
  -p 127.0.0.1:3000:3000 \
  bkimminich/juice-shop

2. Run the security scans

With Nuclei installed locally:

./scripts/run-all.sh

To specify a different target:

TARGET_URL=http://127.0.0.1:3000 ./scripts/run-all.sh

Jenkins Setup

Jenkins runs in a custom Docker image based on jenkins/jenkins:lts-jdk21, with Nuclei installed.

The Jenkinsfile uses the following target:

http://juice-shop-lab:3000

Jenkins must be connected to the same Docker network as Juice Shop.

The Pipeline configuration uses Pipeline script from SCM to load Jenkinsfile directly from GitHub.

Scan Results

During testing, Nuclei identified OWASP Juice Shop and reported several configuration-related findings.

Finding	Result
Missing Subresource Integrity (SRI)	Detected
Missing Content-Security-Policy	Detected
Missing Referrer-Policy	Detected
Other missing HTTP security headers	Detected

These were informational findings, not confirmed exploitable vulnerabilities.

One technology fingerprint also matched qm-system, which may be a false positive.

Current Status

* Docker-based Jenkins and Juice Shop environment
* Automated Nuclei scans
* Jenkins Pipeline execution
* GitHub SCM integration
* JSON artifact archiving
* Update Nuclei and validate templates
* Add severity-based security gates
* Generate HTML security reports
* Configure automatic pipeline triggers

Notes

The pipeline has completed successfully in Jenkins.

Testing used Nuclei v3.3.8. Some templates produced compatibility warnings.

Scan rates are limited, and potentially intrusive template categories are excluded.

Generated reports are excluded from Git because they may contain HTTP request and response data.

Disclaimer: This project is intended for local testing and learning. Only scan systems you own or are authorized to test.
