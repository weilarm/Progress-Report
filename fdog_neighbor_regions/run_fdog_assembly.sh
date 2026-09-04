#!/bin/bash
#SBATCH --job-name=fdog_assembly
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=8G
#SBATCH --partition=all,inteli7
#SBATCH --array=1-80%4
#SBATCH --output=logs_assembly/fdog_%A_%a.out
#SBATCH --error=logs_assembly/fdog_%A_%a.err

LINE=$((SLURM_ARRAY_TASK_ID + 1))
INPUT=$(sed -n "${LINE}p" summary.tsv)

echo "$INPUT"

rep=$(echo "$INPUT" | cut -f8)
echo "$rep"
protid=$(echo "$INPUT" | cut -f2)
echo "$protid"
neighborid=$(echo "$INPUT" | cut -f3)
echo "$neighborid"
core_gene=$(echo "$INPUT" | cut -f9)
echo "$core_gene"
core_gene="${core_gene//|/_}"; core_gene="${core_gene//./_}"
echo "$core_gene"


if [ "$rep" == "True" ]; then
	fdog.assembly \
	 --gene "$core_gene" \
	 --refSpec BRACO@38358@014529535_1 \
	 --dataPath /share/project/mieke/fdog_neighbor_regions \
	 --metaeukDb /share/gluster/NOTLOESUNG/freya/uniref100/uniref100 \
	 --out  /share/project/mieke/fdog_neighbor_regions/"$protid"/output \
	 --parallel


fi
