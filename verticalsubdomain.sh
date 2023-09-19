#!/bin/bash

# Initialize an array to store subdomains
declare -a subdomains

# Function to enumerate subdomains using Subfinder
enumerate_subdomains() {
    local target="$1"
    subdomains=($(subfinder -d "$target" | sort -u))
}

# Function to re-enumerate subdomains up to a specified depth and save the results
reenumerate_subdomains() {
    local depth="$1"
    local current_depth=1

    while [ "$current_depth" -le "$depth" ]; do
        # Output current subdomains to a text file
        echo "Level $current_depth Subdomains:" >> verticalsubdomain.txt
        for subdomain in "${subdomains[@]}"; do
            echo "$subdomain" >> verticalsubdomain.txt
        done

        # Enumerate subdomains for the next level
        for subdomain in "${subdomains[@]}"; do
            enumerate_subdomains "$subdomain"
        done

        current_depth=$((current_depth + 1))
    done
}

# Main script

# Accept target domain as user input
read -p "Enter the target domain: " target_domain

# Specify the depth for re-enumeration
depth=5  # Change this to the desired depth

# Initial subdomain enumeration
enumerate_subdomains "$target_domain"

# Re-enumerate subdomains up to the specified depth and save the results
reenumerate_subdomains "$depth"
