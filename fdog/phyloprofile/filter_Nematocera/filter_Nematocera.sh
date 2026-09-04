#!/bin/bash

# Input PhyloProfile file
PHYLOPROFILE="/share/gluster/Projects/vinh/fdog_ms/usecase_cellulase/data_ingo_ms/pPCD-PhylogeneticProfiles/cellulase_all.phyloprofile.valid"

# Text file containing the values that should match the ncbi id column
LISTE1="Nematocera_ids.txt"

# Text file containing the 65 seed protein IDs from fDA
LISTE2="filter_seeds.txt"

# Output file
OUTPUT="Nematocera_fDOG_derived.phyloprofile"


awk '
BEGIN {
    OFS="\t"
    #The first list (Nematocera tax ids) is read into an array, liste1
    while ((getline line < "'"$LISTE1"'") > 0) {
        liste1[line] = 1
    }
    close("'"$LISTE1"'")


    #The second list (65 seed protein IDs) is read in to another array, liste2
    while ((getline line < "'"$LISTE2"'") > 0) {
        liste2[line] = 1
    }
    close("'"$LISTE2"'")
}


{
    #First check if ncbi ID is found in liste1
    if ($2 in liste1) {


        
        #2nd check if the seed protein is from Rhizoctonia solani (contains "QRW" followed by numbers, . and more numbers)
        if (match($1, /QRW[0-9]+\.[0-9]+/)) {

            #this part from QRW... is extracted, as it corresponds to the names of the seed proteins in the core_orthologs directory  
            qrw = substr($1, RSTART, RLENGTH)


            #3rd check if this substring is in liste2
            if (qrw in liste2) {
		$1=substr($1, index($1, "QRW"))
                print
            }
        }
    }
}
' "$PHYLOPROFILE" > "$OUTPUT"


# message when script is finished
echo "Finished. Output written to: $OUTPUT"
