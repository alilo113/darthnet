#!/bin/bash

mkdir -p ../data/intel

collect_js_files() {
    echo "[+] Collecting JavaScript files"

    cat ../data/discovery/*_live.txt \
        | sort -u \
        | katana -silent \
        | grep -Ei '\.js($|\?)' \
        | sort -u \
        > ../data/intel/js_files.txt
}

extract_endpoints() {
    echo "[+] Extracting endpoints from JavaScript files"

    cat ../data/intel/js_files.txt \
        | while read -r js; do
            curl -s "$js"
        done \
        | grep -Eo '(/api/[a-zA-Z0-9_/?=&-]+)' \
        | sort -u \
        > ../data/intel/js_endpoints.txt
}

extract_secrets() {
    echo "[+] Extracting secrets from JavaScript files"

    trufflehog git \
        --json \
        --rules ./trufflehog-rules/ \
        --only-verified \
        ../data/intel/js_files.txt \
        > ../data/intel/js_secrets.json
}