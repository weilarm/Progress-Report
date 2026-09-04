#!/bin/bash
#SBATCH --job-name=fdog-core
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --partition=all


fdogs.run\
 --seqFolder /share/project/mieke/fdog_neighbor_regions/XP_037025833.1/seed_proteins \
 --refspec BRACO@38358@014529535_1 \
 --jobName fdog-core \
 --corepath  /share/project/mieke/fdog_neighbor_regions/coreTaxadir \
 --searchpath /share/project/mieke/fdog_neighbor_regions/searchTaxa_dir \
 --annopath /share/project/mieke/fdog_neighbor_regions/annotation_dir \
 --outpath  /share/project/mieke/fdog_neighbor_regions/XP_037025833.1/core_orthologs \
 --coreOnly 




