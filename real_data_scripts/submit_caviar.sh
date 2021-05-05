#!/bin/sh
#$ -S /bin/bash
#$ -N job-hdl_caviar
#$ -cwd
#$ -o stdout-hdl_caviar.out
#$ -M nathanl2012@gmail.com
#$ -l h_data=16G,h_rt=24:00:00
#$ -t 1-187:1

source ~/.bash_profile

#python analysis_scripts/run_caviar_all_bbj_ukb.py

{ /usr/bin/time -f "time result\ncmd:%C\nreal %es\nuser %Us \nsys  %Ss \nmemory:%MKB \ncpu %P" python analysis_scripts/run_caviar_all_bbj_ukb.py $SGE_TASK_ID bbj pruned ; } 2> timing/timing_caviar_bbj_pruned_${SGE_TASK_ID}.txt
{ /usr/bin/time -f "time result\ncmd:%C\nreal %es\nuser %Us \nsys  %Ss \nmemory:%MKB \ncpu %P" python analysis_scripts/run_caviar_all_bbj_ukb.py $SGE_TASK_ID ukb pruned ; } 2> timing/timing_caviar_ukb_pruned_${SGE_TASK_ID}.txt

{ /usr/bin/time -f "time result\ncmd:%C\nreal %es\nuser %Us \nsys  %Ss \nmemory:%MKB \ncpu %P" python analysis_scripts/run_caviar_all_bbj_ukb.py $SGE_TASK_ID bbj unpruned ; } 2> timing/timing_caviar_bbj_unpruned_${SGE_TASK_ID}.txt
{ /usr/bin/time -f "time result\ncmd:%C\nreal %es\nuser %Us \nsys  %Ss \nmemory:%MKB \ncpu %P" python analysis_scripts/run_caviar_all_bbj_ukb.py $SGE_TASK_ID ukb unpruned ; } 2> timing/timing_caviar_ukb_unpruned_${SGE_TASK_ID}.txt
#
