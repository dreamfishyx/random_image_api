#!/bin/bash

API_KEY_FILE="/app/api_key.txt"

new_key=$(openssl rand -hex 32)

echo "$new_key" >"$API_KEY_FILE"

echo -e "\n\033[1;32m========================================"
echo -e "New API key generated:"
echo -e "\033[1;31m$new_key\033[0m"
echo -e "\033[1;32m========================================\033[0m\n"
