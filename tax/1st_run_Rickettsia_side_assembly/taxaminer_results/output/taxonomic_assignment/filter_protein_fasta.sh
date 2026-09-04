#!/bin/bash

comm -23 <(sort gene_hits_Stenotrophomonas_maltophilia.txt)  <(sort all_hypothetical_proteins.txt) > non_hypothetical_proteins_Stenotrophomonas_maltophilia.txt

sed -i 's/$/-0/' non_hypothetical_proteins_Stenotrophomonas_maltophilia.txt

seqkit grep -f non_hypothetical_proteins_Stenotrophomonas_maltophilia.txt /share/project/mieke/tax/1st_run_Rickettsia_side_assembly/taxaminer_results/output/proteins.faa > Stenotrophomonas_maltophilia.faa

