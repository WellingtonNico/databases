#!/bin/bash

find . -name ".git" -prune -o -name "*.sample" -print | while read -r sample_file; do
    target_file="${sample_file%.sample}"

    if [ ! -f "$target_file" ]; then
        cp "$sample_file" "$target_file"
        echo "Copiado: $sample_file -> $target_file"
    else
        echo "Ignorado: $target_file já existe"
    fi
done