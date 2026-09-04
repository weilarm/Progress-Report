#!/bin/bash

output_dir="./results"
mkdir -p $output_dir


if [ $# -ne 1 ]; then
    echo "command line: $0 <R1.fastq.gz>"
    exit 1
fi

R1="$1"


# check if files exist in given directory
if [ ! -f "$R1" ]; then
    echo "Error: file '$R1' does not exist"
    exit 1
fi

#check for correct format of files
if [[ "$R1" != *.fastq.gz ]]; then
    echo "Error: '$R1' is not a .fastq.gz-file"
    exit 1
fi

echo "running Nanoplot..."

NanoPlot \
    --fastq $R1 \
    --outdir $output_dir \
    --format svg
