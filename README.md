Nuclei Security Pipeline

Automated security scanning with Jenkins, Docker and Nuclei.

I built this project to run security scans through Jenkins instead of executing them manually each time. It uses OWASP Juice Shop as the test application and stores the scan results as Jenkins build artifacts.

⸻

Architecture

                 GitHub Repository
                         |
                         v
                    Jenkins CI
                         |
                +--------+--------+
                |                 |
                v                 v
           Check Target      OWASP Juice Shop
                |              (Docker)
                v
        Technology Detection
                |
                v
        Misconfiguration Scan
                |
                v
           JSON Reports
          (Build Artifacts)

Jenkins reads the Jenkinsfile from GitHub and runs Nuclei against Juice Shop over a shared Docker network.

⸻

Pipeline Stages

Stage	What it does
01 — Check Target	Confirms Juice Shop is reachable.
02 — Technology Detection	Runs Nuclei technology templates.
03 — Misconfiguration Scan	Checks for common security misconfigurations.

Reports are archived after each build.

⸻

Project Structure

nuclei-security-pipeline/
│
├── Dockerfile.jenkins
├── Jenkinsfile
├── .gitignore
├── README.md
│
└── scripts/
    ├── tech-scan.sh
    ├── misconfig-scan.sh
    └── run-all.sh

⸻

Run Locally

1. Start Juice Shop

docker run -d --name juice-shop-lab \
  -p 127.0.0.1:3000:3000 \
  bkimminich/juice-shop

2. Run Nuclei scans

Requires Nuclei to be installed locally.

./scripts/run-all.sh

3. Change the target (optional)

TARGET_URL=http://127.0.0.1:3000 ./scripts/run-all.sh

Jenkins Environment

Jenkins runs in a custom Docker image based on jenkins/jenkins:lts-jdk21, with Nuclei installed.

Both containers must be connected to the same Docker network. The Jenkins pipeline targets:

http://juice-shop-lab:3000

⸻

Scan Findings

The initial scans returned several configuration-related findings.

Finding	Severity
Missing Subresource Integrity (SRI)	Info
Missing Content-Security-Policy	Info
Missing Referrer-Policy	Info
Other missing security headers	Info

Note: These findings are informational and should not be treated as confirmed exploitable vulnerabilities.

Technology detection also returned a possible false-positive fingerprint for qm-system.

⸻

Current Limitations

* Nuclei version: v3.3.8 (some templates produced compatibility warnings).
* Scan scope: Rate-limited, with potentially intrusive template categories excluded.
* Reports: JSON files are excluded from Git because they may contain HTTP request and response data.

⸻

Next Improvements

* Update Nuclei and validate templates
* Add severity-based security gates
* Generate an HTML report
* Automate pipeline triggers

⸻

Disclaimer: This project is intended for local testing. Only scan systems you own or are authorized to test.
