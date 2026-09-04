#!/bin/bash
#SBATCH --job-name=fdog
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --partition=all
#SBATCH --array=1-100%4
#SBATCH --output=logs/fdog_%A_%a.out
#SBATCH --error=logs/fdog_%A_%a.err

INPUT=$(sed -n "${SLURM_ARRAY_TASK_ID}p" seeds.txt)
 
fdog.assembly \
 --gene "$INPUT" \
 --refSpec RHISO@456999@016906535_1 \
 --metaeukDb /share/gluster/NOTLOESUNG/freya/uniref100/uniref100 \
 --dataPath /share/project/mieke/fdog

