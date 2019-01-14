#!/bin/bash

#$ -l highmem,highp,h_rt=62:00:00,h_data=34G
#$ -pe shared 10
#$ -N BQR_MW
#$ -cwd
#$ -m bea
#$ -o /u/flashscratch/d/dechavez/Maned_wolf_raw/BQR/log/BQR_MW.out
#$ -e /u/flashscratch/d/dechavez/Maned_wolf_raw/BQR/log/BQR_MW.err
#$ -M dechavezv

# load your modules:
. /u/local/Modules/default/init/modules.sh
module load java/1.8.0_77
module load picard_tools

echo "#######"
echo "Base_Recalibration"
echo "########"

export VCF_DIR=/u/flashscratch/d/dechavez/Maned_wolf_raw/ISEC/$1_stmp_ug_hc_mbq20_raw_reheader.vcf.gz
export BAM_DIR=/u/flashscratch/d/dechavez/Maned_wolf_raw/BAM/$1_BWA_sortRG_rmdup_realign_fixmate.bam
export BQSR_DIR=/u/flashscratch/d/dechavez/Maned_wolf_raw/BQR
export GATK=/u/local/apps/gatk/3.7/GenomeAnalysisTK.jar
export REF=/u/home/d/dechavez/project-rwayne/canfam31/canfam31.fa
export Recal=/u/flashscratch/d/dechavez/Maned_wolf_raw/BQR/Post_BQR
export PICARD=/u/local/apps/picard-tools/current
export temp=/u/flashscratch/d/dechavez/Maned_wolf_raw/


echo "########"
echo "1st_Base_Recalibration"
echo "#######"

echo -e "\n1st_Base_Recalibration ${1}\n"
≈
java -jar -Xmx30g -Djava.io.tmpdir=/u/scratch/d/dechavez/ ${GATK} \
-T BaseRecalibrator -nt 1 -nct 7 \
-I ${BAM_DIR} \
-R ${REF} \
-knownSites ${VCF_DIR} \
-o ${BQSR_DIR}/cat_samt_ug_hc_$1_raw.vcf.table

echo -e "\nFinished 1stBase Recalibration ${1}\n"

#echo "########"
#echo "2nd_Base_Recalibration"
#echo "#######"

#java -jar -Xmx120g -Djava.io.tmpdir=work/dechavezv/temp ${GATK} \
#-T BaseRecalibrator -nt 1 -nct 7 \
#-I ${BAM_DIR} \
#-R ${REF} \
#-knownSites ${VCF_DIR} \
#-BQSR ${BQSR_DIR}/cat_samt_ug_hc_fb_SRR2971425_raw.vcf.table \
#-o ${BQSR_DIR}/post_recal_SRR2971425_QD30.vcf.table

echo -e "\nPrint Reads ${1}\n"

java -jar -Xmx30g -Djava.io.tmpdir=work/dechavezv/temp ${GATK} \
-T PrintReads -nt 1 -nct 12 \
-I ${BAM_DIR} \
-R ${REF} \
-BQSR ${BQSR_DIR}/cat_samt_ug_hc_$1_raw.vcf.table \
-o ${BQSR_DIR}/2nd_call_cat_samt_ug_hc_$1_raw.vcf.table.bam

echo -e "\nFinished Printing Reads ${1}\n"

###echo "########"
###echo "AnalyzeCovariates"
###echo "########"

### java -jar -Xmx120g -Djava.io.tmpdir=work/dechavezv/temp ${GATK} \
#### -T AnalyzeCovariates -l DEBUG \
#### -R ${REF} \
#### -csv my-report.csv \
#### -before ${BQSR_DIR}/cat_samt_ug_hc_fb_SRR2971425_raw.vcf.table \
#### -after ${BQSR_DIR}/post_recal_SRR2971425_QD30.vcf.table \
#### -plots ${BQSR_DIR}/PLOTS_post_recal_SRR2971425.vcf.table.pdf
 

# Index the bam
echo -e "\nIndexing 2nd_call_cat_samt_ug_hc_${1}_raw.vcf.table.bam\n"

java -jar -Xmx8g -Djava.io.tmpdir=${temp} ${PICARD} BuildBamIndex \
INPUT=${BQSR_DIR}/2nd_call_cat_samt_ug_hc_$1_raw.vcf.table.bam \
OUTPUT=${BQSR_DIR}/2nd_call_cat_samt_ug_hc_$1_raw.vcf.table.bam.bai \
VALIDATION_STRINGENCY=LENIENT \
TMP_DIR=${temp}

echo -e "\nFinished Indexing 2nd_call_cat_samt_ug_hc_${1}_raw.vcf.table.bam\n"
