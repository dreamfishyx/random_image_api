#!/bin/bash

cd /app/images || exit

for file in *; do
  if [[ "$file" == *.webp ]]; then
    echo "$file is already in WEBP format. Skipping..."
    continue
  fi

  if file "$file" | grep -qE 'image|bitmap'; then
    echo "Converting $file to WEBP format..."
    cwebp -quiet "$file" -o "${file%.*}.webp"

    if [[ -f "${file%.*}.webp" ]]; then
      echo "$file successfully converted. Deleting original..."
      rm "$file"
    else
      echo "Failed to convert $file. Skipping deletion."
    fi
  else
    echo "$file is not a supported image format. Deleting..."
    rm "$file"
  fi
done
