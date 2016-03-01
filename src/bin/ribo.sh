#!/usr/bin/env bash

# Copy the index into ramdisk
#mkdir /dev/shm/bowtie_indx/
#cp /project/flatiron/tonya/img_bowtie_builds/*.bt2l /dev/shm/bowtie_indx

# Set up the experiment parameters
TRIAL_HOME=/project/flatiron/ben/shallow-seq/results/SKTSL-downsampling-2015-12-31-15
PROJECT_HOME=/project/flatiron/ben/NINJA-Shogun
DATA_HOME=/project/flatiron/ben/data/ribo

FASTQ_HOME=/export/scratch/ben/msi
FASTQ_RNA=${PROJECT_HOME}/data/ribo/fastq_rna.txt
FASTQ_DNA=${PROJECT_HOME}/data/ribo/fasta_dna.txt

# test for directory
test -d ${DATA_HOME}/dna | mkdir -p  ${DATA_HOME}/dna
while read line; do
  echo ${FASTQ_HOME}/${line}
  LINE_WITHOUT_EXTENSION=${line%.fastq}
  time java -jar /project/flatiron/ben/bin/Trimmomatic-0.35/trimmomatic-0.35.jar \
    SE -phred33 ${FASTQ_HOME}/${line} \
    ${DATA_HOME}/dna/${LINE_WITHOUT_EXTENSION}.trimmed.fastq \
    -threads 16 \
    ILLUMINACLIP:/project/flatiron/ben/bin/Trimmomatic-0.35/adapters/TruSeq2-PE.fa:2:30:10 \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 >> ${DATA_HOME}/dna/README.txt
done <$FASTQ_RNA



# Run the full trial
#bowtie2 --no-unal --no-hd -x /dev/shm/bowtie_indx/img.gene.bacteria.bowtie  --np 0 --mp "1,1" \
#--rdg "0,1" --rfg "0,1" --score-min "L,0,-0.02" --norc -f ${IN_FILE} --very-sensitive -a -p 48 \
#| python unsorted_last_common_ancestor.py -x  /project/flatiron/data/img/00.taxon.tab.txt \
#-o ${TRIAL_HOME}/results_full.csv -

## Grab the entire number of reads once for downsampling
#NUM_READS="$(grep -c "^>" ${IN_FILE})"
#
#k=(1000 10000 100000 1000000 10000000)
#
#for i in ${k[@]}; do
#    # Make the directory to store down-sampling results
#    test -d ${TRIAL_HOME}/hits_${i} | mkdir -p ${TRIAL_HOME}/hits_${i}
#    for j in `seq 1 10`; do
#        # An experiment
#        subset_fasta.py -n ${NUM_READS} -k ${i} ${IN_FILE}\
#        | bowtie2 --no-unal --no-hd -x /dev/shm/bowtie_indx/img.gene.bacteria.bowtie  --np 0 --mp "1,1" \
#        --rdg "0,1" --rfg "0,1" --score-min "L,0,-0.02" --norc -f - --very-sensitive -a -p 48 \
#        | unsorted_last_common_ancestor.py -x  /project/flatiron/data/img/00.taxon.tab.txt \
#        -o ${TRIAL_HOME}/hits_${i}/results_${j}.csv -
#    done
#done
#
## Clear the ramdisk
#rm -r /dev/shm/bowtie_indx
