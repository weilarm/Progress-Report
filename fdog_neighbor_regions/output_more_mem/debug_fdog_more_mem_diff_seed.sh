#!/bin/bash
#SBATCH --job-name=fdog_assembly
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=16G
#SBATCH --partition=special


fdog.assembly \
 --gene XP_037025810_1_LOC119067131_1302 \
 --refSpec BRACO@38358@014529535_1 \
 --dataPath /share/project/mieke/fdog_neighbor_regions \
 --metaeukDb /share/gluster/NOTLOESUNG/freya/uniref90/UniRef90 \
 --parallel \
 --debug \
 --tmp \
 --out ./output_more_mem
