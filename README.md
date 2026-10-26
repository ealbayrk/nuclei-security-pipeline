Nuclei Security Pipeline

A small security automation lab built with Jenkins, Docker, and Nuclei.

I built this project to get hands-on experience with running security scans as part of a CI/CD pipeline instead of executing them manually.

The target application is OWASP Juice Shop, running in a separate Docker container.

How it works

Jenkins and Juice Shop run on the same Docker network. Jenkins uses Nuclei to scan the application and stores the results as JSON build artifacts.

The pipeline has three stages:

1. Check Target — Make sure Juice Shop is reachable.
2. Technology Detection — Identify technologies using Nuclei templates.
3. Misconfiguration Scan — Check for common security misconfigurations.

Scan reports are archived after each build.

Project structure

.
├── Dockerfile.jenkins
├── Jenkinsfile
├── scripts/
│   ├── tech-scan.sh
│   ├── misconfig-scan.sh
│   └── run-all.sh
└── README.md

Running locally

The scripts assume Juice Shop is available at http://127.0.0.1:3000.

With Docker and Nuclei installed, start Juice Shop:

docker run -d --name juice-shop-lab \
  -p 127.0.0.1:3000:3000 \
  bkimminich/juice-shop

Then run:

./scripts/run-all.sh

The target can also be overridden:

TARGET_URL=http://127.0.0.1:3000 ./scripts/run-all.sh

For Jenkins, I used a custom Docker image based on jenkins/jenkins:lts-jdk21 with Nuclei installed.

The Jenkinsfile targets http://juice-shop-lab:3000, so Jenkins needs to be connected to the same Docker network as Juice Shop.

Scan results

During testing, Nuclei identified OWASP Juice Shop and reported several configuration-related findings, including:

* Missing Subresource Integrity (SRI) attributes on external resources
* Missing Content-Security-Policy header
* Missing Referrer-Policy header
* Other missing HTTP security headers

These were informational findings, not confirmed exploitable vulnerabilities.

One technology fingerprint also matched qm-system, which may be a false positive.

Notes

The pipeline completed successfully in Jenkins, including both scanning stages and artifact archiving.

The tested environment used Nuclei v3.3.8. Some templates produced compatibility warnings, so updating Nuclei and validating the templates is still on my list.

The scan rate is limited, and potentially intrusive template categories are excluded.

Generated reports are kept out of Git because they can contain HTTP request and response data.

This is a local lab project. Only run security scans against systems you own or have permission to test.
