#!/bin/bash
# 进入图片目录
cd /app/images

# 遍历目录中的所有文件
for file in *; do
  # 检查文件是否为图片类型
  if file "$file" | grep -qE 'image|bitmap'; then
    # 检查文件是否为WEBP格式，如果是，则跳过
    if file "$file" | grep -qE 'image/webp'; then
      echo "$file is already in WEBP format. Skipping..."
      continue
    fi

    # 如果是其他图片格式，转换为WEBP
    cwebp -quiet "$file" -o "${file%.*}.webp"
    rm "$file" # 删除原始文件
  else
    # 如果不是图片类型,删除文件
    echo "$file is not an image. Deleting..."
    rm "$file"
  fi
done
