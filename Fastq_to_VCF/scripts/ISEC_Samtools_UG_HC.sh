#! /bin/bash

#$ -l highp,h_rt=26:00:00,h_data=6G
#$ -pe shared 1
#$ -N IsecBD
#$ -cwd
#$ -m bea
#$ -o /u/flashscratch/d/dechavez/Maned_wolf_raw/ISEC/log/IsecBD.out
#$ -e /u/flashscratch/d/dechavez/Maned_wolf_raw/ISEC/log/IsecBD.err
#$ -M dechavezv

# Before using this script make sure that you have all the vcf file compress (.gz) and indexed (.tbi)
# You can use the following commands to compress the file
# bigzip -c <your_vcf_file> > <compress_vcf>.gz
# tabix -p vcf <compress_vcf>.gz


export GATK_UG=/u/flashscratch/d/dechavez/Maned_wolf_raw/UG_VCF/ManedWolf_BWA_sortRG_rmdup_realign_fixmate_UG_Allchr.vcf.gz
export Samt=/u/flashscratch/d/dechavez/Maned_wolf_raw/mpileup/ManedWolf_BWA_sortRG_rmdup_realign_fixmate_mpileup_Allchr.vcf.gz
export GATK_HC=/u/flashscratch/d/dechavez/Maned_wolf_raw/HC_VCF/ManedWolf_BWA_DupIndelFixmate_HC_Allchr.vcf.gz
export OUT=/u/flashscratch/d/dechavez/Maned_wolf_raw/ISEC

cd ${OUT} /
## /u/home/d/dechavez/tabix-0.2.6/bgzip -c ${Samt} > ${Samt}.gz
## /u/home/d/dechavez/tabix-0.2.6/bgzip -c ${GATK_UG} > ${GATK_UG}.gz
## /u/home/d/dechavez/tabix-0.2.6/tabix -p vcf ${Samt}.gz
## /u/home/d/dechavez/tabix-0.2.6/tabix -p vcf ${GATK_UG}.gz
/u/home/d/dechavez/bcftools/bcftools isec -n +2 -c none -O v -p . ${Samt} ${GATK_UG} ${GATK_HC}
for file in 000*vcf; do /u/home/d/dechavez/tabix-0.2.6/bgzip ${file}; /u/home/d/dechavez/tabix-0.2.6/tabix -p vcf ${file}.gz; done
/u/home/d/dechavez/bcftools/bcftools concat -a -O v `ls 000*.vcf.gz` > ManedWolf_stmp_ug_hc_mbq20_raw.vcf
sed 's/Number=1/Number=./;s/,Version="3">/>/' ManedWolf_stmp_ug_hc_mbq20_raw.vcf > ManedWolf_stmp_ug_hc_mbq20_raw_reheader.vcf
/u/home/d/dechavez/tabix-0.2.6/bgzip -c ManedWolf_stmp_ug_hc_mbq20_raw_reheader.vcf > ManedWolf_stmp_ug_hc_mbq20_raw_reheader.vcf.gz
/u/home/d/dechavez/tabix-0.2.6/tabix -p vcf ManedWolf_stmp_ug_hc_mbq20_raw_reheader.vcf.gz
rm ManedWolf_stmp_ug_hc_mbq20_raw.vcf
