from Bio import SeqIO
import pandas as pd
from pathlib import Path
import re
import gffutils

#create pandas data frame_structure, which will store the content of the summary.tsv
df = pd.DataFrame({"RS_ID": [],
"BC_ID": [],
"Neighbor_ID": [],
"Gene_ID": [],
"Chrom": [],
"Start":[],
"End":[],
"Rep":[],
"core_id":[]})

#paths to relevant files
phyloprofile = Path("/share/project/mieke/fdog/phyloprofile/final_merge_rep.phyloprofile")
QRW_ids = Path("/share/project/mieke/fdog_neighnor_regions/select_seeds/rep_Bradysia_only.txt")

pp = pd.read_csv(phyloprofile, sep="\t")

#check format (data frame)
#print(pp.head())

with open(QRW_ids, "r") as f:
	QRWs = [line.strip() for line in f]

#check format (list of strings)
#print(QRWs)

#iterate through the rows of data frame and extract the protein_IDs of the othologs of QRWs found in B. coprophila (ncbi38358)
d = dict()
p_ids = set()
for i in range(len(pp["geneID"])):
	QRW = pp["geneID"][i] #take QRW ID of the row i and check whether it corresponds to one of the IDS in QRWs and if its and ortholog found in B. coprophila
	if QRW in QRWs and pp["ncbiID"][i] == "ncbi38358":
		ortho_id = pp["orthoID"][i]
		#extract the protein ID XP_....
		match = re.search(r"[^|]*\|[^|]*\|([^|]*)", ortho_id)
		protein_id = match.group(1)
		
		print("Found", protein_id, "for", QRW)
		#as one protein_ID can be found as ortholog for more than one QRW-ID and one QRW-ID can find several matches within the B. coprophila proteome (f.ex. paralogs), we use a dict
		if protein_id not in d:
			d[protein_id] = list()
		d[protein_id].append(QRW)
		#p_ids is a list of all orthologs
		p_ids.add(protein_id)

#print(len(p_ids))

#path to fasta of B. coprophila proteome (1:1 (protein to gene), as it only contains the protein sequences of longest isoforms)


gff_db = gffutils.FeatureDB("genome.db")

db = gffutils.FeatureDB("genome.db")


#path to fasta of B. coprophila proteome (1:1 (protein to gene), as it only contains the protein sequences of longest isoforms)
prot_longest_isoforms = "/share/gluster/GeneSets/NCBI-Genomes/InvertebratesRefSeq/raw_dir/active/GCF_014529535.1/protein.rep.fa" 

#Maybe some proteins are on the same gene and have therefore the same longest isoform in the proteome fasta
#genomic_set is introduced as variable to determine which proteins (XP_...) have the same genomic_region/ neighbors
genomic_set = {}

#introduced as variable to avoid redundant steps for the same protein_ids
seen = set()

#we iterate through all CDS entries, as they have the protein_ids as attributes
for cds in list(db.features_of_type("CDS")):
	p_id = cds.attributes["protein_id"][0]
	if p_id in p_ids and not p_id in seen : #check whether the p_id is of interest and has not been identfied before
		#print("Protein ID", p_id, "found")
		g = cds.attributes["gene"][0] #g is the gene name
		#print("Gene:", g)

		#track back: from cds -> mRNA -> gene
		mrna = next(db.parents(cds))
		gene = next(db.parents(mrna))

		#get list of genes
		#1 that are on the same strand as the gene of the current p_id
		#2 that is a protein-coding gene
		genes = list(gene_entry for gene_entry in db.features_of_type("gene") if gene_entry.strand == gene.strand and gene_entry.attributes["gene_biotype"][0] == "protein_coding")
		#sort the genes by their position on the strand
		genes.sort(key = lambda x: (x.chrom, x.start))
		#get the position of the gene of out current p_id (ID of the ortholog of R. solani found in B. coprophila)
		i = genes.index(gene)

		#define neighbord for gene of p_id
		genomic_region = genes[max(i-3,0):i+4]

		#identification of p_ids with the same "gene-neighborhood"
		#we use a frozenset so we can use ist as key
		g_set =frozenset([g.id for g in genomic_region])
		if g_set not in genomic_set:
			genomic_set[g_set]=list()
		genomic_set[g_set].append(p_id)

		#get all the information for our summary.tsv
		#most importantly get the protein ID of the longest isoforms of all genes for each genomic neighborhood
		for g in genomic_region:
			for record in SeqIO.parse(prot_longest_isoforms, "fasta"):
				if g.attributes["gene"][0] in record.id:
					#print(record.id)
					#print(g.chrom)
					#print(g.start)
					#print(g.end)
					#print(g.attributes["gene"][0])
					#print(tuple(d[p_id]))
					#print(p_id)
					#print()
					match = re.search(r"([^|]*)\|[^|]*\|[^|]*", record.id)
					neighbor = match.group(1)
					df.loc[len(df["RS_ID"])] = [
					", ".join(d[p_id]),
					p_id,
					neighbor,
					g.attributes["gene"][0],
					g.chrom,
					g.start,
					g.end,
					True,
					record.id]
		seen.add(p_id)
		if len(seen) == len(p_ids):
			break

#post-modification to mark representatives, so don't have to run slurm jobs for the same genomic regions
double_BC_ids = set(entry for key in genomic_set for entry in genomic_set[key] if len(genomic_set[key]) > 1 and entry != genomic_set[key][-1])
for index, row in df.iterrows():
	if row["BC_ID"] in double_BC_ids:
		df.loc[index, "Rep"] = False

#safe to summary.tsv
df.to_csv("/share/project/mieke/fdog_neighbor_regions/summary.tsv", sep="\t", index = False)

