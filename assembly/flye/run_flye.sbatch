#!/bin/bash
#SBATCH --job-name=flye-assembly
#SBATCH --cpus-per-task=24
#SBATCH --mem=128G
#SBATCH --partition=all
#SBATCH --nodelist=compute05
#SBATCH --time=24:00:00
#SBATCH --output=flye.out
#SBATCH --error=flye.err

flye \
--nano-hq /share/project/mieke/assembly/rawreads/SRR34469290_1.fastq.gz \
--out-dir /share/project/mieke/assembly/flye \
--threads 24 \
--meta
