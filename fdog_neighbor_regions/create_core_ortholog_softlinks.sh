#!/bin/bash

while IFS=$'\t' read RS_ID BC_ID Neighbor_ID Gene_ID Chrom Start End Rep core_id; do
	target=/share/project/mieke/fdog_neighbor_regions/"$BC_ID"/core_orthologs/core_orthologs
	
	if [[ "$Rep" == "True" ]]; then
		echo "BC_ID: $BC_ID"
        	echo "Rep: $Rep"
        	echo "Target: $target"

        	for file in "$target"/*; do
            		echo "Linke: $file"
            		ln -s "$file" /share/project/mieke/fdog_neighbor_regions/core_orthologs/
		done
	fi

done < <(tail -n +2 summary.tsv)
