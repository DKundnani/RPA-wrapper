#!usr/bin/env bash
#First position argument: Location of RibosepreferredAnalysis github repository
#Seond positional argument: Reference fasta file
#third positional argument : Location for range files
#fourth positional argument : location of bed files
#fifth positional argument : location of order files

source ~/p-fstorici3-0/rich_project_bio-storici/bin/RPA-wrapper/Heatmapwrapper.sh

for bed in $(ls ~/p-fstorici3-0/rich_project_bio-storici/HEKnH9/anno/subtypes/*.bed); do
#bg_freq ~/p-fstorici3-0/rich_project_bio-storici/bin/RibosePreferenceAnalysis/ ~/p-fstorici3-0/rich_project_bio-storici/reference/hg38/filtered_hg38.fa ${bed} 
sample_freq ~/p-fstorici3-0/rich_project_bio-storici/bin/RibosePreferenceAnalysis/ ~/p-fstorici3-0/rich_project_bio-storici/reference/hg38/filtered_hg38.fa ${bed} ~/p-fstorici3-0/rich_project_bio-storici/HEKnH9/bed/OG_bed/
norm_freq ~/p-fstorici3-0/rich_project_bio-storici/bin/RibosePreferenceAnalysis/ ~/p-fstorici3-0/rich_project_bio-storici/reference/hg38/filtered_hg38.fa ${bed} ~/p-fstorici3-0/rich_project_bio-storici/HEKnH9/bed/OG_bed/
resort_plot ~/p-fstorici3-0/rich_project_bio-storici/bin/RibosePreferenceAnalysis/ ~/p-fstorici3-0/rich_project_bio-storici/reference/hg38/filtered_hg38.fa ${bed} ~/p-fstorici3-0/rich_project_bio-storici/HEKnH9/bed/OG_bed/ ~/p-fstorici3-0/rich_project_bio-storici/HEKnH9/order 
done