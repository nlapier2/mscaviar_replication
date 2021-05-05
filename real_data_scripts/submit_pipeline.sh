#!/bin/sh
#$ -S /bin/bash
#$ -N job-hdl_pipeline
#$ -cwd
#$ -o stdout-hdl_pipeline.out
#$ -M nathanl2012@gmail.com
#$ -m abe
#$ -l h_data=32G,highp,h_rt=12:00:00

source ~/.bash_profile

python analysis_scripts/sumstats_mscaviar_pipeline.py --infiles reformatted_sumstats/bbj_hdl_sumstats_reformatted.tsv reformatted_sumstats/ukb_hdl_sumstats_reformatted.tsv --outdir loci_win500kb_minpeakZ5pt2_minsnpZ1pt96_min10snp/ --populations EAS EUR --population_sizes 70657 361194 --exclude_chromosome_six --processes 12 --window_size 1000000 --min_snp_zscore 1.96 --min_peak_zscore 5.2

# Original PLOS Genetics submission settings
###NOT USED### python MsCAVIAR/utils/sumstats_mscaviar_pipeline.py --infiles reformatted_sumstats/bbj_hdl_sumstats_reformatted.tsv reformatted_sumstats/ukb_hdl_sumstats_reformatted.tsv --outdir loci_minpeakZ5pt2_minsnpZ3pt9_min10snp/ --populations EAS EUR --population_sizes 70657 361194 --exclude_chromosome_six --processes 12 #--min_snps 10 
#python MsCAVIAR/utils/sumstats_mscaviar_pipeline.py --infiles reformatted_sumstats/bbj_hdl_sumstats_reformatted.tsv reformatted_sumstats/ukb_hdl_sumstats_reformatted.tsv --outdir loci_win500kb_minpeakZ5pt2_minsnpZ3pt9_min10snp/ --populations EAS EUR --population_sizes 70657 361194 --exclude_chromosome_six --processes 12 --window_size 1000000 
#
