#!/bin/bash

BASE_DIR="/share/project/mieke/fdog"
OUTPUT="fDA_combined_phyloprofile.phyloprofile"

first_file=true

find "$BASE_DIR" -type f -name 'QRW*.phyloprofile' | while read -r file; do
    echo "found: $file"

    if $first_file; then
        cat "$file" > "$OUTPUT"
        first_file=false
        #we only keep the header of the first phyloprofile

    else
        # we only add the entries of all other phyloprofiles
        tail -n +2 "$file" >> "$OUTPUT"
    fi
done

echo "merged into: $OUTPUT"
