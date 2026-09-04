#!/bin/bash

grep "product=hypothetical protein" /share/project/mieke/tax/1st_run_Rickettsia_side_assembly/prokka_output/cds_only.gff \
 | awk -F'\t' '{print $9}' \
 | awk -F';' '{print $1}' \
 | sed -E 's/ID=(.*)/\1/g' > all_hypothetical_proteins.txt
