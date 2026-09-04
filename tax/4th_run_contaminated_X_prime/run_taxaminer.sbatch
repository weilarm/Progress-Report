#!/bin/bash
#SBATCH --job-name=taxaminer-contaminated
#SBATCH --cpus-per-task=24
#SBATCH --mem=64G
#SBATCH --partition=all,inteli7
#SBATCH --time=7-00:00:00


PYTHONNOUSERSITE=1 taxaminer.run config.yml
