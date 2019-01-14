#!/bin/bash
#$ -l highp,h_rt=24:00:00,h_data=15G
#$ -pe shared 1
#$ -N UG_ManedWolf
#$ -cwd
#$ -m bea
#$ -o /u/flashscratch/d/dechavez/Maned_wolf_raw/UG_VCF/log/UG_Bushdog.out
#$ -e /u/flashscratch/d/dechavez/Maned_wolf_raw/UG_VCF/log/UG_Bushdog.err
#$ -M dechavezv
#### #$ -t 1-3:1
##### $(printf %02d $SGE_TASK_ID).


# then load your modules:
. /u/local/Modules/default/init/modules.sh
module load java


echo " ####### "
echo " UG_BAM "
echo " ######## "


export BAM=/u/flashscratch/d/dechavez/Maned_wolf_raw/BAM/SplitBams/ManedWolf_BWA_sortRG_rmdup_realign_fixmate.bam_chr$1.bam
export Output=/u/flashscratch/d/dechavez/Maned_wolf_raw/UG_VCF
export Reference=/u/home/d/dechavez/project-rwayne/canfam31/canfam31.fa
export temp=/u/flashscratch/d/dechavez/Maned_wolf_raw/UG_VCF/temp


##nt 1
##nct 1

java -jar -Xmx8g -Djava.io.tmpdir=${temp} /u/local/apps/gatk/3.8.0/GenomeAnalysisTK.jar \
-T UnifiedGenotyper \
-R ${Reference} \
-I ${BAM} \
--output_mode EMIT_VARIANTS_ONLY \
--min_base_quality_score 20 \
-stand_call_conf 30.0 \
-o ${Output}/ManedWolf_BWA_sortRG_rmdup_realign_fixmate_UG_$1.vcf.gz \
-metrics ${Output}/ManedWolf_BWA_sortRG_rmdup_realign_fixmate_UG_$1.vcf.metrics \
-glm BOTH
