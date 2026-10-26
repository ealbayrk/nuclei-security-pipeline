<div align="center">

Nuclei Security Pipeline

Jenkins · Docker · Nuclei · OWASP Juice Shop

Automated security scans in a containerized Jenkins environment.

</div>

⸻

01 / About

I wanted to see how Nuclei would fit into a Jenkins pipeline, so I set up a local Docker lab with OWASP Juice Shop as the target.

Jenkins pulls the pipeline from GitHub, runs the scans and keeps the JSON results with each build.

02 / Pipeline

GitHub
  │
  ▼
Jenkins
  │
  ├── Check Target
  │
  ├── Technology Detection
  │
  └── Misconfiguration Scan
  │
  ▼
JSON Build Artifacts

Jenkins and Juice Shop communicate over a shared Docker network.

03 / Repository

nuclei-security-pipeline/
├── Dockerfile.jenkins
├── Jenkinsfile
├── .gitignore
├── README.md
└── scripts/
    ├── tech-scan.sh
    ├── misconfig-scan.sh
    └── run-all.sh

04 / Running the Lab

Start Juice Shop

docker run -d --name juice-shop-lab \
  -p 127.0.0.1:3000:3000 \
  bkimminich/juice-shop

Run the scans

Nuclei must be installed locally.

./scripts/run-all.sh

To use a different target:

TARGET_URL=http://127.0.0.1:3000 ./scripts/run-all.sh

For Jenkins, I built a custom image based on jenkins/jenkins:lts-jdk21 with Nuclei installed.

The Jenkins container needs access to Juice Shop at http://juice-shop-lab:3000.

05 / What Nuclei Found

The first scans returned mostly missing security headers and SRI-related findings.

Finding	Severity
Missing Subresource Integrity	INFO
Missing Content-Security-Policy	INFO
Missing Referrer-Policy	INFO
Other missing security headers	INFO

These are informational findings, not confirmed exploitable vulnerabilities.

Technology detection also returned a qm-system fingerprint that may be a false positive.

06 / Notes

The pipeline has been tested with Nuclei v3.3.8. Some templates generated compatibility warnings.

Scan rates are limited, potentially intrusive template categories are excluded, and generated JSON reports are not committed to Git.

I’m planning to add severity-based build checks and improve reporting as I continue working on the project.

⸻

<div align="center">

Built for local security testing. Only scan systems you own or are authorized to test.

</div>
