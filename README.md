<div align="center">

# Nuclei Security Pipeline

**Template-based security scanning in a Jenkins pipeline**

<img alt="Jenkins" src="https://img.shields.io/badge/Jenkins-D24939?style=flat-square&logo=jenkins&logoColor=white" /> <img alt="Docker" src="https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white" /> <img alt="Nuclei" src="https://img.shields.io/badge/Nuclei-6D4AFF?style=flat-square" /> <img alt="OWASP Juice Shop" src="https://img.shields.io/badge/OWASP-Juice%20Shop-F7B93E?style=flat-square" />

</div>

## What this does

I started experimenting with Nuclei and Jenkins while writing about dynamic application security testing. This repository is the working Docker-based version of that experiment: Jenkins reads a `Jenkinsfile` from GitHub, scans a local OWASP Juice Shop instance, and keeps the results with the build.

**Target:** OWASP Juice Shop (local container)  
**Output:** JSON reports archived in Jenkins  
**Status:** GitHub SCM checkout verified; scans tested in Jenkins

## How the scan runs

```text
   GitHub (Jenkinsfile)
           |
           v
        Jenkins --------------------+
           |                       |
     1. Check target               |
           |                       v
     2. Detect technologies   OWASP Juice Shop
           |                   (Docker container)
     3. Scan misconfigurations      ^
           |                       |
           +---- Nuclei HTTP ------+
           |
           v
     Archived JSON reports
```

Jenkins and Juice Shop share a Docker network. The pipeline uses rate limits and excludes potentially intrusive template categories from the misconfiguration scan.

## Files

```text
nuclei-security-pipeline/
├── Dockerfile.jenkins
├── Jenkinsfile
├── .gitignore
├── README.md
└── scripts/
    ├── tech-scan.sh
    ├── misconfig-scan.sh
    └── run-all.sh
```

## Run it locally

**1 — Start the target**

```bash
docker run -d --name juice-shop-lab \
  -p 127.0.0.1:3000:3000 \
  bkimminich/juice-shop
```

**2 — Run the scripts** (requires Nuclei installed on your machine)

```bash
./scripts/run-all.sh
```

You can override the target URL:

```bash
TARGET_URL=http://127.0.0.1:3000 ./scripts/run-all.sh
```

**Jenkins setup:** The custom image in `Dockerfile.jenkins` is based on `jenkins/jenkins:lts-jdk21` and includes Nuclei. Connect Jenkins and Juice Shop to the same Docker network; the `Jenkinsfile` uses `http://juice-shop-lab:3000`. Configure the job as **Pipeline script from SCM**, branch `main`, script path `Jenkinsfile`.

## Findings from the lab

The initial scans reported missing Subresource Integrity (SRI) attributes and several missing HTTP security headers, including `Content-Security-Policy` and `Referrer-Policy`.

These results were **informational**, not proof of an exploitable vulnerability. A `qm-system` technology fingerprint also appeared and may be a false positive.

The environment used **Nuclei v3.3.8**. Some templates raised compatibility warnings; updating the scanner and validating templates are still outstanding.

## Background reading

I covered the original Nuclei/DAST experiment, including a manual scan and an earlier Jenkins example, in my Medium post:

**[Dynamic Application Security Testing (DAST): NUCLEI](https://medium.com/@ealbayrk0/active-security-scanning-using-semgrep-dependency-check-trufflehog-and-cdxgen-9a822477f1df)** · February 2025

The article shows the earlier approach; this repository documents the current containerized setup.

---

<sub>Local security lab only. Scan systems you own or have explicit permission to test. Generated JSON reports are excluded from Git because they may contain HTTP request and response data.</sub>
