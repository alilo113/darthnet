#!/bin/bash

domain=$1

if [ -z "$domain" ]; then
  echo "Usage: ./discovery.sh <domain>"
  exit 1
fi

mkdir -p ../data/discovery

subdomains_discovery() {
    echo "[+] Subdomain discovery for $domain"
    subfinder -d "$domain" -silent > ../data/discovery/${domain}_subs.txt
}

live_subdomains_discovery() {
    echo "[+] Checking live subdomains"
    httpx -silent -l ../data/discovery/${domain}_subs.txt \
      -sc -title -tech-detect \
      > ../data/discovery/${domain}_fingerprint.txt

    awk '{print $1}' ../data/discovery/${domain}_fingerprint.txt \
      > ../data/discovery/${domain}_live.txt
}

fingerprinting() {
    echo "[+] Fingerprinting completed via httpx output"
}

# ---- EXECUTION ORDER ----
subdomains_discovery
live_subdomains_discovery
fingerprinting