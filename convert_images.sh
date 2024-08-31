#!/bin/bash

cd /app/images || exit

for file in *; do
  if [[ "$file" == *.webp ]]; then
    echo "$file is already in WEBP format. Skipping..."
    continue
  fi

  if file "$file" | grep -qE 'image|bitmap'; then
    mogrify -strip "$file"
    echo "Converting $file to WEBP format..."
    cwebp -quiet "$file" -o "${file%.*}.webp"
    rm "$file"
  else
    echo "$file is not an image. Deleting..."
    rm "$file"
  fi
done
