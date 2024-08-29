#!/bin/bash

# 定义API密钥存储文件路径
API_KEY_FILE="/app/api_key.txt"

# 生成新的API密钥
new_key=$(openssl rand -hex 32)

# 将新密钥覆盖写入文件
echo "$new_key" >"$API_KEY_FILE"

# 打印新生成的API密钥，使用颜色和格式使其更显眼
echo -e "\n\033[1;32m========================================"
echo -e "New API key generated:"
echo -e "\033[1;31m$new_key\033[0m" # 红色加粗显示API密钥
echo -e "\033[1;32m========================================\033[0m\n"
