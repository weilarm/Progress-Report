#!/bin/bash
#SBATCH --job-name=fdog
#SBATCH --cpus-per-task=8
#SBATCH --mem=64
#SBATCH --partition=all
#SBATCH --time=24:00:00


fdog.assembly \
 --gene QRW19403.1 \
 --refSpec RHISO@456999@016906535_1 \
 --metaeukDb /share/gluster/NOTLOESUNG/freya/uniref100/uniref100 \
 --dataPath /share/project/mieke/fdog
