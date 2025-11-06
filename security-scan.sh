#!/usr/bin/env bash

echo "===== Running Gitleaks (Secret Scan) ====="
docker run --rm -v $(pwd):/repo zricethezav/gitleaks:latest \
  detect --source=/repo --report-path=/repo/gitleaks-report.json --no-color
echo "Gitleaks report saved to gitleaks-report.json"
echo

echo "===== Running Trivy Config Scan (IaC, Dockerfiles, Compose, K8s) ====="
docker run --rm -v $(pwd):/project aquasec/trivy:latest \
  config /project
echo

echo "===== Building Docker Image ====="
docker build -t testapp .
echo

echo "===== Running Trivy Image Scan ====="
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:latest \
  image testapp
echo

echo "===== Running Checkov (Terraform + K8s Security) ====="
docker run --rm -v $(pwd):/scan bridgecrew/checkov:latest \
  -d /scan
echo

echo "✅ ALL SCANS COMPLETE."

