#!usr/bin/env bash

#Wrapper script for Ribosepreference analysis from Penghao
###########################################################
#Get mono, di and tri nucleotide frequencies from BED files overlapping a range file(bed format)
#Usage: source ./Heatmapwrapper.sh
#split_by_subtypes ~/p-fstorici3-0/rich_project_bio-storici/HEKnH9/anno/subtypes/sorted_finalcpganno_requiredchr.bed 7

#Following script needs to be run from the required output folder

#for bed in $(ls ~/p-fstorici3-0/rich_project_bio-storici/HEKnH9/anno/subtypes/*.bed); do
#bg_freq ~/p-fstorici3-0/rich_project_bio-storici/bin/RibosePreferenceAnalysis/ ~/p-fstorici3-0/rich_project_bio-storici/reference/hg38/filtered_hg38.fa ${bed} 
#sample_freq ~/p-fstorici3-0/rich_project_bio-storici/bin/RibosePreferenceAnalysis/ ~/p-fstorici3-0/rich_project_bio-storici/reference/hg38/filtered_hg38.fa ${bed} ~/p-fstorici3-0/rich_project_bio-storici/HEKnH9/bed/OG_bed/
#norm_freq ~/p-fstorici3-0/rich_project_bio-storici/bin/RibosePreferenceAnalysis/ ~/p-fstorici3-0/rich_project_bio-storici/reference/hg38/filtered_hg38.fa ${bed} ~/p-fstorici3-0/rich_project_bio-storici/HEKnH9/bed/OG_bed/
#resort_plot ~/p-fstorici3-0/rich_project_bio-storici/bin/RibosePreferenceAnalysis/ ~/p-fstorici3-0/rich_project_bio-storici/reference/hg38/filtered_hg38.fa ${bed} ~/p-fstorici3-0/rich_project_bio-storici/HEKnH9/bed/OG_bed/ ~/p-fstorici3-0/rich_project_bio-storici/HEKnH9/order 
#done

#scripts='/storage/home/hcoda1/5/dkundnani3/p-fstorici3-0/rich_project_bio-storici/bin/RibosePreferenceAnalysis/'
#ref='/storage/home/hcoda1/5/dkundnani3/p-fstorici3-0/rich_project_bio-storici/reference/sacCer2/sacCer2.fa'
# range='/storage/home/hcoda1/5/dkundnani3/p-fstorici3-0/rich_project_bio-storici/AGS/ranges/nucl.bed'
# range='/storage/home/hcoda1/5/dkundnani3/p-fstorici3-0/rich_project_bio-storici/AGS/ranges/chrM.bed'
# range='/storage/home/hcoda1/5/dkundnani3/p-fstorici3-0/rich_project_bio-storici/AGS/ranges/2micron.bed'
#bed='/storage/home/hcoda1/5/dkundnani3/p-fstorici3-0/rich_project_bio-storici/AGS/bed/'
# order='/storage/home/hcoda1/5/dkundnani3/p-fstorici3-0/rich_project_bio-storici/AGS/order'
# bg_freq $scripts $ref $range 
# sample_freq $scripts $ref $range $bed
# norm_freq $scripts $ref $range $bed
# resort_plot $scripts $ref $range $bed $order


split_by_subtypes () {
        #$1=bed12 file with ranges
        #$2=col number of subtypes
        subtypes=$(cut -f${2} ${ranges} | sort | uniq)
        for subtype in ${subtypes}; do grep ${subtype} ${ranges} > ${subtype}_${ranges}; done
}

#intersect multiple bed files with multiple ranges
intersect_multiple () {
        #$1=range files w/ location
        #$2=bedfiles w/ location
        #$3=output folder
        mkdir ${3}
        for range in $(ls ${1}/*bed); do 
        mkdir ${3}/$(basename ${range} .bed)
                for file in $(ls ${2}/*.bed); do
                bedtools intersect -nonamecheck -b ${range} -a ${file} > ${3}/$(basename $range .bed)/$(basename $file)
                done
        done
}

intersect_multiple_ss () {
        mkdir ${3}
        for range in $(ls ${1}/*bed); do 
        mkdir ${3}/$(basename ${range} .bed)
                for file in $(ls ${2}/*.bed); do
                bedtools intersect -s -nonamecheck -b ${range} -a ${file} > ${3}/$(basename $range .bed)/$(basename $file)
                done
        done
}


bg_freq () {
        #$1=Location of Scripts/git repo
        #$2=Ref fasta
        #$3=bed12 file of ranges
        #Usage1: bg_freq ~/p-fstorici3-0/rich_project_bio-storici/bin/RibosePreferenceAnalysis/ ~/p-fstorici3-0/rich_project_bio-storici/reference/hg38/filtered_hg38.fa ~/p-fstorici3-0/rich_project_bio-storici/HEKnH9/anno/subtypes/hg38_cpg_islands.bed
        #Usage2: bg_freq ~/p-fstorici3-0/rich_project_bio-storici/bin/RibosePreferenceAnalysis/ ~/p-fstorici3-0/rich_project_bio-storici/reference/sacCer2/sacCer2.fa ~/p-fstorici3-0/rich_project_bio-storici/AGS/ranges/chrM.bed
        
        
        mkdir bg_freq
        bedtools getfasta -fi ${2} -bed ${3} > ./bg_freq/$(basename ${3} .bed).fa
        python3 ${1}/count_background.py ./bg_freq/$(basename ${3} .bed).fa -o ./bg_freq/$(basename ${3} .bed).di
        python3 ${1}/get_chrom.py ./bg_freq/$(basename ${3} .bed).di -s chr0 -v -o ./bg_freq/$(basename ${3} .bed).di.freq
        python3 ${1}/count_background.py ./bg_freq/$(basename ${3} .bed).fa --mono -o ./bg_freq/$(basename ${3} .bed).mono
        python3 ${1}/get_chrom.py ./bg_freq/$(basename ${3} .bed).mono -s chr0 -v -o ./bg_freq/$(basename ${3} .bed).mono.freq
        python3 ${1}/count_background.py ./bg_freq/$(basename ${3} .bed).fa --trinuc -o ./bg_freq/$(basename ${3} .bed).tri
        python3 ${1}/get_chrom.py ./bg_freq/$(basename ${3} .bed).tri -s chr0 -v -o ./bg_freq/$(basename ${3} .bed).tri.freq
}

sample_freq () {
        #$1=Location of Scripts/git repo
        #$2=Ref fasta
        #$3=bed12 file of ranges
        #$4=location of bed files
        #Usage1: sample_freq ~/p-fstorici3-0/rich_project_bio-storici/bin/RibosePreferenceAnalysis/ ~/p-fstorici3-0/rich_project_bio-storici/reference/hg38/filtered_hg38.fa ~/p-fstorici3-0/rich_project_bio-storici/HEKnH9/anno/subtypes/hg38_cpg_islands.bed ~/p-fstorici3-0/rich_project_bio-storici/HEKnH9/bed/OG_bed/
        mkdir sample_freq
        mkdir sample_freq/$(basename ${3} .bed)
        for file in $(ls ${4}/*.bed); do
        #bedtools intersect -nonamecheck -b ${3} -a ${file} > ./sample_freq/$(basename ${3} .bed)/$(basename ${file})
        bedtools intersect -s -nonamecheck -b ${3} -a ${file} > ./sample_freq/$(basename ${3} .bed)/$(basename ${file})
        done
        python3 ${1}/count_rNMP.py ${2} ./sample_freq/$(basename ${3} .bed)/*.bed -d -m -t -o ./sample_freq/$(basename ${3} .bed)/
        #python3 ${1}/count_rNMP.py ${2} ./sample_freq/$(basename ${3} .bed)/*.bed --dist 0 -d -m -t -o ./sample_freq/$(basename ${3} .bed)/
        python3 ${1}/get_chrom.py ./sample_freq/$(basename ${3} .bed)/*.mono -s chr0 -v -o ./sample_freq/$(basename ${3} .bed)_sample.mono
        python3 ${1}/get_chrom.py ./sample_freq/$(basename ${3} .bed)/*.dinuc_d1_nr -s chr0 -v -o ./sample_freq/$(basename ${3} .bed)_sample.dinuc_d1_nr
        python3 ${1}/get_chrom.py ./sample_freq/$(basename ${3} .bed)/*.dinuc_d1_rn -s chr0 -v -o ./sample_freq/$(basename ${3} .bed)_sample.dinuc_d1_rn
        python3 ${1}/get_chrom.py ./sample_freq/$(basename ${3} .bed)/*.trinuc_nnr -s chr0 -v -o ./sample_freq/$(basename ${3} .bed)_sample.trinuc_nnr
        python3 ${1}/get_chrom.py ./sample_freq/$(basename ${3} .bed)/*.trinuc_nrn -s chr0 -v -o ./sample_freq/$(basename ${3} .bed)_sample.trinuc_nrn
        python3 ${1}/get_chrom.py ./sample_freq/$(basename ${3} .bed)/*.trinuc_rnn -s chr0 -v -o ./sample_freq/$(basename ${3} .bed)_sample.trinuc_rnn
        
}

norm_freq () {
        #$1=Location of Scripts/git repo
        #$2=Ref fasta
        #$3=bed12 file of ranges
        #$4=location of bed files
        #Usage1: sample_freq ~/p-fstorici3-0/rich_project_bio-storici/bin/RibosePreferenceAnalysis/ ~/p-fstorici3-0/rich_project_bio-storici/reference/hg38/filtered_hg38.fa ~/p-fstorici3-0/rich_project_bio-storici/HEKnH9/anno/subtypes/hg38_cpg_islands.bed ~/p-fstorici3-0/rich_project_bio-storici/HEKnH9/bed/
        mkdir norm_freq
        python3 ${1}/normalize.py ./sample_freq/$(basename ${3} .bed)_sample.mono ./bg_freq/$(basename ${3} .bed).mono.freq -o ./norm_freq/$(basename ${3} .bed)_mono_0 --name $(basename ${3} .bed)
        python3 ${1}/normalize.py ./sample_freq/$(basename ${3} .bed)_sample.dinuc_d1_nr ./bg_freq/$(basename ${3} .bed).di.freq --group_len 4 -o ./norm_freq/$(basename ${3} .bed)_dinuc_nr_4 --name $(basename ${3} .bed)
        python3 ${1}/normalize.py ./sample_freq/$(basename ${3} .bed)_sample.dinuc_d1_rn ./bg_freq/$(basename ${3} .bed).di.freq --group_len 4 -o ./norm_freq/$(basename ${3} .bed)_dinuc_rn_4 --name $(basename ${3} .bed)
        python3 ${1}/normalize.py ./sample_freq/$(basename ${3} .bed)_sample.trinuc_nnr ./bg_freq/$(basename ${3} .bed).tri.freq --group_len 16 -o ./norm_freq/$(basename ${3} .bed)_trinuc_nnr_16 --name $(basename ${3} .bed)
        python3 ${1}/normalize.py ./sample_freq/$(basename ${3} .bed)_sample.trinuc_nrn ./bg_freq/$(basename ${3} .bed).tri.freq --group_len 16 -o ./norm_freq/$(basename ${3} .bed)_trinuc_nrn_16 --name $(basename ${3} .bed)
        python3 ${1}/normalize.py ./sample_freq/$(basename ${3} .bed)_sample.trinuc_rnn ./bg_freq/$(basename ${3} .bed).tri.freq --group_len 16 -o ./norm_freq/$(basename ${3} .bed)_trinuc_rnn_16 --name $(basename ${3} .bed)
        
}

resort_plot() {
        #$1=Location of Scripts/git repo
        #$2=Ref fasta
        #$3=bed12 file of ranges
        #$4=location of bed files
        #$5=order file
        #Usage1: resort_plot ~/p-fstorici3-0/rich_project_bio-storici/bin/RibosePreferenceAnalysis/ ~/p-fstorici3-0/rich_project_bio-storici/reference/hg38/filtered_hg38.fa ~/p-fstorici3-0/rich_project_bio-storici/HEKnH9/anno/subtypes/hg38_cpg_islands.bed ~/p-fstorici3-0/rich_project_bio-storici/HEKnH9/bed/ 
        for file in $(ls ./norm_freq/$(basename ${3} .bed)*[0-9]); do 
        python3 ${1}/resort.py ${file} ${5} -o ./norm_freq/sorted_$(basename $file)
        done

        mkdir plots 
        for file in $(ls ./norm_freq/sorted_$(basename ${3} .bed)*mono*); do
        python3 ${1}/draw_heatmap.py ${file} -b ./bg_freq/$(basename ${3} .bed).mono.freq --background_chrom $(basename ${3} .bed) -o ./plots/$(basename $file)
        done
        for file in $(ls ./norm_freq/sorted_$(basename ${3} .bed)*dinuc*); do
        python3 ${1}/draw_heatmap.py ${file} -b ./bg_freq/$(basename ${3} .bed).di.freq --background_chrom $(basename ${3} .bed) -o ./plots/$(basename $file)
        done
        for file in $(ls ./norm_freq/sorted_$(basename ${3} .bed)*trinuc*); do
        python3 ${1}/draw_heatmap.py ${file} -b ./bg_freq/$(basename ${3} .bed).tri.freq --background_chrom $(basename ${3} .bed) -o ./plots/$(basename $file)
        done

}

