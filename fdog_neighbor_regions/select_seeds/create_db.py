import gffutils

gffutils.create_db("/share/gluster/GeneSets/NCBI-Genomes/InvertebratesRefSeq/raw_dir/active/GCF_014529535.1/genomic.gff", dbfn="genome.db", force = True, merge_strategy="create_unique")

