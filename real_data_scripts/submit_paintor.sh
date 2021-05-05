#!/bin/sh
#$ -S /bin/bash
#$ -N job-hdl_paintor
#$ -cwd
#$ -o stdout-hdl_paintor.out
#$ -M nathanl2012@gmail.com
#$ -l h_data=16G,h_rt=24:00:00
#$ -t 1-187:1

source ~/.bash_profile

#python analysis_scripts/run_paintor_all_bbj_ukb.py
#python analysis_scripts/make_paintor_sets_bbj_ukb.py 

#{ /usr/bin/time -f "time result\ncmd:%C\nreal %es\nuser %Us \nsys  %Ss \nmemory:%MKB \ncpu %P" python analysis_scripts/run_paintor_all_bbj_ukb.py $SGE_TASK_ID pruned ; } 2> timing/timing_paintor_pruned_${SGE_TASK_ID}.txt

{ /usr/bin/time -f "time result\ncmd:%C\nreal %es\nuser %Us \nsys  %Ss \nmemory:%MKB \ncpu %P" python analysis_scripts/run_paintor_all_bbj_ukb.py $SGE_TASK_ID unpruned ; } 2> timing/timing_paintor_unpruned_${SGE_TASK_ID}.txt
#
