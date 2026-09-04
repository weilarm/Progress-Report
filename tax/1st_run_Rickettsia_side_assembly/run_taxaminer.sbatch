#!/bin/bash
#SBATCH --job-name=taxaminer-prokka
#SBATCH --cpus-per-task=24
#SBATCH --mem=64G
#SBATCH --partition=all
#SBATCH --time=7-00:00:00
#SBATCH --output=taxaminer.out
#SBATCH --error=taxaminer.err

PYTHONNOUSERSITE=1 taxaminer.run config.yml
