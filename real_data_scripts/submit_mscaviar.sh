#!/bin/sh
#$ -S /bin/bash
#$ -N job-hdl_mscaviar
#$ -cwd
#$ -o stdout-hdl_mscaviar.out
#$ -M nathanl2012@gmail.com
#$ -l h_data=16G,highp,h_rt=168:00:00  
# exclusive,h_rt=335:00:00
#$ -t 1-187:1

source ~/.bash_profile

#python analysis_scripts/run_mscaviar_all_bbj_ukb.py

#{ /usr/bin/time -f "time result\ncmd:%C\nreal %es\nuser %Us \nsys  %Ss \nmemory:%MKB \ncpu %P" python analysis_scripts/run_mscaviar_all_bbj_ukb.py $SGE_TASK_ID pruned ; } 2> timing/timing_mscaviar_pruned_${SGE_TASK_ID}.txt 1> timing/timing_mscaviar_pruned_${SGE_TASK_ID}_breakdown.txt

{ /usr/bin/time -f "time result\ncmd:%C\nreal %es\nuser %Us \nsys  %Ss \nmemory:%MKB \ncpu %P" python analysis_scripts/run_mscaviar_all_bbj_ukb.py $SGE_TASK_ID unpruned ; } 2> timing/timing_mscaviar_unpruned_${SGE_TASK_ID}.txt 1> timing/timing_mscaviar_unpruned_${SGE_TASK_ID}_breakdown.txt
#
