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

extract_query_parameters(){
    echo "[+] Extracting query parameters from JavaScript files"

    cat ../data/intel/js_files.txt \
        | while read -r js; do
            curl -s "$js"
        done \
        | grep -Eo '([?&][a-zA-Z0-9_=-]+)' \
        | sort -u \
        > ../data/intel/js_query_parameters.txt
}

extract_api_routes(){
    echo "[+] Extracting API routes from javaScript files"

    cat ../data/intel/js_files.txt \ 
        | while read -r js; do
            curl -s "$js"
        done \
        | grep -Eo '(/api/[a-zA-Z0-9_/?=&-]+)' \
        | sort -u \
        > ../data/intel/js_api_routes.txt
}

extract_json_keys(){
    echo "[+] Extracting JSON keys from JavaScript files"

    cat ../data/intel/js_files.txt \
        | while read -r js; do
            curl -s "$js"
        done \ 
        | grep -Eo '"([a-zA-Z0-9_]+)"\s*:' \
        | sort -u \
        > ../data/intel/js_json_keys.txt
}