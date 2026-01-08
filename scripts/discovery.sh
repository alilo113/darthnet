#!/bin/bash

subdomains_discovery(){
    read -p "Enter the domain: " domain
    echo "Starting subdomain discovery for $domain..."
    # Using subfinder for subdomain discovery
    subfinder -d $domain -o subs.txt
    echo "Subdomain discovery completed. Results saved in subs.txt"
}

live_subdomains_discovery(){
    echo "Checking for live subdomains..."
    # Using httpx to check for live subdomains
    httpx -l subs.txt -sc -fc 400,404,500 -o live.txt
    echo "Live subdomain discovery completed. Results saved in live.txt"
}

fingerprinting(){
    echo "Starting fingerprinting of live subdomains..."
    # Using nuclei for fingerprinting
    nuclei -l live.txt -o fingerprints.txt
    echo "Fingerprinting completed. Results saved in fingerprints.txt"

}