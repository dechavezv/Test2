#!/bin/bash

#$ -l highp,h_rt=40:00:00,h_data=14G
#$ -pe shared 1
#$ -N MW_BamtoFasta
#$ -cwd
#$ -m bea
#$ -o ./MW_BamtoFasta.out
#$ -e ./MW_BamtoFasta.err
#$ -M dechavezv


# then load your modules:
. /u/local/Modules/default/init/modules.sh
module load bcftools/1.2 
module load samtools/1.2
module load bedtools/2.26.0

export BAM=2nd_call_cat_samt_ug_hc_ManedWolf_raw.vcf.table.bam
export REF=/u/home/d/dechavez/project-rwayne/canfam31/canfam31.fa
export Output=/u/flashscratch/d/dechavez/Maned_wolf_raw/BQR/GenomeFasta
export neutral=/u/home/d/dechavez/project-rwayne/Besd_Files/BushDogAndMAnedWolf/Canis_familiaris_FGF.bed
export VCF=/u/flashscratch/d/dechavez/Maned_wolf_raw/BQR/mpileup/2nd_call_cat_samt_ug_hc_ManedWolf_ALLchr_mpileup.vcf

echo -e "\n Getting genome in FASTA format\n"

cd ${Output}

samtools mpileup -Q 20 -q 20 -u -f ${REF} ${BAM} | \
bcftools call -v -c > ${BAM}.vcf

echo -e "\n Finisined process of getting genome in FASTA format\n"
