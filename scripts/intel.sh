#!/bin/bash

mkdir -p ../data/intel

review_webserver_metadata_for_information_leakage(){
    echo "[+] Reviewing webserver metadata for information leakage from robots.txt and nmap scans"
    cat ../data/discovery/*_live.txt \
        | while read -r url; do
            robots_url="${url%/}/robots.txt"
            echo "[*] Fetching $robots_url"
            curl -O -Ss "$robots_url"
        done \
        | grep -Eo 'Disallow: (/[a-zA-Z0-9_/-]+)' \
        | sed 's/Disallow: //' \
        | sort -u \
        > ../data/intel/robots_disallowed_paths.txt

    echo "[+] Reviewing webserver metadata for information leakage from sitmap.xml"
    cat ../data/discovery/*_live.txt \
        | while read -r url; do
            sitemap_url="${url%/}/sitemap.xml"
            echo "[*] Fetching $sitemap_url"
            wget --no-verbose "$sitemp_url" && head -n8 sitemap.xml
        done \ 
        | grep -Eo '<loc>(http[s]?://[a-zA-Z0-9_./?-]+)</loc>' \
        | sed 's/<loc>//;s/<\/loc>//' \
        | sort -u \
        > ../data/intel/sitemap_urls.txt

    echo "[+] Reviewing webserver metadata for information leakage from security.txt"
    cat ../data/discovery/*_live.txt \
        | while read -r url; do
            securitytxt_url="${url%/}/.well-known/security.txt"
            echo "[*] Fetching $securitytxt_url"
            wget --no-verbose "$securitytxt_url" && cat security.txt
        done \
        | grep -Eo 'Contact: (mailto:[a-zA-Z0-9_.@-]+)' \
        | sed 's/Contact: //' \     
        | sort -u \
        > ../data/intel/securitytxt_contacts.txt
    
    echo "[+] Reviewing webserver metadata for information leakage from humans.txt"
    cat ../data/discovery/*_live.txt \
        | while read -r url; do
            humanstxt_url="${url%/}/humans.txt"
            echo "[*] Fetching $humanstxt_url"
            wget --no-verbose "$humanstxt_url" && cat humans.txt
        done \
        | grep -Eo '([a-zA-Z0-9_.@-]+@[a-zA-Z0-9_.-]+)' \
        | sort -u \
        > ../data/intel/humanstxt_contacts.txt
}

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