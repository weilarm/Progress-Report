#!/bin/bash
#SBATCH --job-name=fdog-core
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --partition=all,inteli7
#SBATCH --array=1-10%4
#SBATCH --output=logs/fdog_%A_%a.out
#SBATCH --error=logs/fdog_%A_%a.err

INPUT=$(sed -n "${SLURM_ARRAY_TASK_ID}p" p_ids_of_pPCDs.txt)
 
fdogs.run\
 --seqFolder /share/project/mieke/fdog_neighbor_regions/"$INPUT"/seed_proteins \
 --refspec BRACO@38358@014529535_1 \
 --jobName fdog-core \
 --corepath  /share/project/mieke/fdog_neighbor_regions/coreTaxadir \
 --searchpath /share/project/mieke/fdog_neighbor_regions/searchTaxa_dir \
 --annopath /share/project/mieke/fdog_neighbor_regions/annotation_dir \
 --outpath  /share/project/mieke/fdog_neighbor_regions/"$INPUT"/core_orthologs \
 --coreOnly 




