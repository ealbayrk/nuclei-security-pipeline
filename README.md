Nuclei Security Pipeline

Automated security scanning with Jenkins, Docker and Nuclei.

This is a small lab project where I integrated Nuclei into a Jenkins pipeline to scan a containerized instance of OWASP Juice Shop.

The goal was to move from running individual scans in the terminal to having a repeatable process with saved results.

Pipeline

GitHub
   |
   v
Jenkins
   |
   +-- Check Target
   |
   +-- Technology Detection
   |
   +-- Misconfiguration Scan
   |
   v
JSON Reports (Jenkins Artifacts)

Jenkins pulls the Jenkinsfile from GitHub, checks whether Juice Shop is reachable, and runs two Nuclei scans.

The reports are archived as build artifacts.

Stack

Tool	Purpose
Jenkins	Pipeline execution
Docker	Containerized lab environment
Nuclei	Security scanning
OWASP Juice Shop	Test application
GitHub	Source control

Repository

nuclei-security-pipeline/
├── Dockerfile.jenkins
├── Jenkinsfile
├── scripts/
│   ├── tech-scan.sh
│   ├── misconfig-scan.sh
│   └── run-all.sh
└── README.md

Run locally

Start Juice Shop:

docker run -d --name juice-shop-lab \
  -p 127.0.0.1:3000:3000 \
  bkimminich/juice-shop

Run the scans (requires Nuclei):

./scripts/run-all.sh

To override the target:

TARGET_URL=http://127.0.0.1:3000 ./scripts/run-all.sh

For Jenkins, I used a custom image based on jenkins/jenkins:lts-jdk21 with Nuclei installed.

Jenkins and Juice Shop share a Docker network, allowing the pipeline to reach the application at http://juice-shop-lab:3000.

Findings

The scans detected several missing security headers and SRI attributes.

Examples:

* Missing Content-Security-Policy
* Missing Referrer-Policy
* Missing Subresource Integrity (SRI)
* Other missing HTTP security headers

These were informational findings, not verified exploitable vulnerabilities.

Technology detection also returned a possible false-positive fingerprint for qm-system.

Limitations

* Tested with Nuclei v3.3.8.
* Some templates generated compatibility warnings.
* Scans use rate limits and exclude potentially intrusive template categories.
* Generated JSON reports are excluded from Git because they can contain HTTP request and response data.

This project runs in a local lab environment. Only scan systems you own or have permission to test.
