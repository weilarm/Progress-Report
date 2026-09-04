#!/bin/bash
#SBATCH --job-name=fdog_assembly
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=8G
#SBATCH --partition=all,inteli7


fdog.assembly \
 --gene XP_037025795_1_LOC119067126_337 \
 --refSpec BRACO@38358@014529535_1 \
 --dataPath /share/project/mieke/fdog_neighbor_regions \
 --fast \
 --debug \
 --tmp \
 --out ./output_debug_tmp_mini_prot_only

