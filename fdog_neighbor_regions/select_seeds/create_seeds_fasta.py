import gffutils
import sys
from Bio import SeqIO
from pathlib import Path


prot_id = sys.argv[1]
print("Search for protein ID:", prot_id)


db = gffutils.FeatureDB("genome.db")
for cds in list(db.features_of_type("CDS")):
	if cds.attributes["protein_id"][0] == prot_id:
		print("Protein ID", prot_id, "found")
		g = cds.attributes["gene"][0]
		print("Gene:", g)
		mrna = next(db.parents(cds))
		gene = next(db.parents(mrna))
		break


print("Gene with name", gene.attributes["gene"][0], "and ID", gene.attributes["ID"][0])
#print(gene.strand)
#Define a list with alle the genes sorted by loci

genes = list(gene_entry for gene_entry in db.features_of_type("gene") if gene_entry.strand == gene.strand and gene_entry.attributes["gene_biotype"][0] == "protein_coding")

genes.sort(key = lambda x: (x.chrom, x.start))

#print(genes[0])
#print(gene)

prot_longest_isoforms = "/share/gluster/GeneSets/NCBI-Genomes/InvertebratesRefSeq/raw_dir/active/GCF_014529535.1/protein.rep.fa"
#find the gene of my protein_ID

i = genes.index(gene)

genomic_region = genes[max(i-3,0):i+4]

print("The genomic region of my gene:",  gene.attributes["gene"][0]) 
for g in  genes[max(i-3, 0):i+4]:
                print(g.id, g.start, g.end, g.attributes)
                print()

print("Found longest isoforms of each protein_coding gene in  genomic_region (defined by +- 3 genes of our original one):")
records =  []
from pathlib import Path

#create output folder
folder = Path(f"/share/project/mieke/fdog_neighbor_regions/testen/{prot_id}/seed_proteins")
folder.mkdir(parents = True, exist_ok=True)

#create fasta file for each seed protein sequence (base to train pHMM in a next step)
for g in genomic_region:
	for record in SeqIO.parse(prot_longest_isoforms, "fasta"):
		if g.attributes["gene"][0] in  record.id:
			print(record.id)
			SeqIO.write(record, f"/share/project/mieke/fdog_neighbor_regions/{prot_id}/seed_proteins/{record.id}.fasta", "fasta")
