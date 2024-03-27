#!/bin/bash

# Set your Telegram bot token and chat ID
TELEGRAM_BOT_TOKEN="<TELEGRAM_BOT_TOKEN>"
TELEGRAM_CHAT_ID="<TELEGRAM_CHAT_ID>"

# Check if the user provided the input and template files as arguments
if [ $# -ne 3 ]; then
    echo "Usage: $0 <input_file> <template_file> <output_file>"
    exit 1
fi

# Assign the arguments to variables
input_file="$1"
template_file="$2"
output_file="$3"

# Run Nuclei scan with the provided input and template files, and capture the output
nuclei_output=$(nuclei -l "$input_file" -c 100 -rl 200 -fhr -lfa -t "$template_file" -o "$output_file")


# Check if the output contains vulnerabilities of HIGH severity
if echo "$nuclei_output" | grep -qE "HIGH"; then
    HIGH_MESSAGE="⚠️ Nuclei found vulnerabilities of HIGH severity!\n\n$nuclei_output"
    
    # Send notification to Telegram for HIGH severity vulnerabilities
    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d "chat_id=${TELEGRAM_CHAT_ID}" \
        -d "text=${HIGH_MESSAGE}"
fi

# Check if the output contains vulnerabilities of MEDIUM severity
if echo "$nuclei_output" | grep -qE "MEDIUM"; then
    MEDIUM_MESSAGE="⚠️ Nuclei found vulnerabilities of MEDIUM severity!\n\n$nuclei_output"
    
    # Send notification to Telegram for MEDIUM severity vulnerabilities
    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d "chat_id=${TELEGRAM_CHAT_ID}" \
        -d "text=${MEDIUM_MESSAGE}"
fi

# Check if the output contains vulnerabilities of CRITICAL severity
if echo "$nuclei_output" | grep -qE "CRITICAL"; then
    CRITICAL_MESSAGE="⚠️ Nuclei found vulnerabilities of CRITICAL severity!\n\n$nuclei_output"
    
    # Send notification to Telegram for CRITICAL severity vulnerabilities
    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d "chat_id=${TELEGRAM_CHAT_ID}" \
        -d "text=${CRITICAL_MESSAGE}"
fi


