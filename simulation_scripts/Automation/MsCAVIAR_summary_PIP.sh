#!/bin/bash
# $ -S /bin/bash
# $ -N job-simulation_MsCaviar_helenhua
# $ -cwd = run from this current working directory (relative paths)
# -o stdout-Simulation.out
# $ -l h_data=6G,h_rt=24:00:00
# $ -t 1-10:1

# source ~/.bash_profile
# source ~/.bashrc
. /u/local/Modules/default/init/modules.sh

SGE_TASK_ID=$1
this_num_causal=$2
num_sim=$3
num_repeat=$4
sim_init_dir=$5 # input directory
out_init_dir=$6 # output directory
pop1='ASN'
pop2='EURO1'
pop3='EURO2'
pop4='EUROs'

out_PIP=${out_init_dir}/'PIP_infile.txt'

for i in $(seq 1 $SGE_TASK_ID); do
    declare -i info=$i-1
    
    if [ -f ${out_init_dir}/${info}/'R_mscaviar_'${info}'_recall_rate.txt' ]
    then
    
        for j in $(seq 1 $num_repeat); do
            sim_dir=${sim_init_dir}/${info}/$j
            out_dir=${out_init_dir}/${info}/$j
                
            for k in $(seq 1 $num_sim); do
                # Capture true causal snps to PIP infile
                awk 'NR==1{printf $1" "}' ${sim_init_dir}/${info}/${pop1}_${j}.causal.snplist >> $out_PIP
                if [ "$this_num_causal" -gt "1" ]; then
                    awk 'NR==2{printf $1" "}' ${sim_init_dir}/${info}/${pop1}_${j}.causal.snplist >> $out_PIP
                    if [ "$this_num_causal" -gt "2" ]; then
                        awk 'NR==3{printf $1" "}' ${sim_init_dir}/${info}/${pop1}_${j}.causal.snplist >> $out_PIP
                    fi
                fi
                printf "\n" >> $out_PIP
                
                # Capture file names
                mscaviar_result=${out_dir}/'mscaviar_'${info}'_'$k'_post.txt'
                mscaviar_result_EUROs=${out_dir}/'mscaviar_'${info}'_'$k'_EUROs_post.txt'
                
                caviar_result1=${out_dir}/'caviar_'${pop1}${info}'_'$k'_post'
                caviar_result2=${out_dir}/'caviar_'${pop2}${info}'_'$k'_post'
                caviar_result3=${out_dir}/'caviar_'${pop3}${info}'_'$k'_post'
                caviar_result4=${out_dir}/'caviar_'${pop4}${info}'_'$k'_post'
                
                paintor_result=${out_dir}/PAINTOR_${this_num_causal}/bothpops_${k}.locus.results
                
                echo "mscaviar "$mscaviar_result >> $out_PIP
                
                echo "caviar_asn "$caviar_result1 >> $out_PIP
                echo "caviar_eur "$caviar_result2 >> $out_PIP
                echo "caviar_euros "$caviar_result4 >> $out_PIP
                
                echo "paintor "$paintor_result >> $out_PIP
                printf "\n" >> $out_PIP

            done
        done
    else
    echo "Region "${info}" did not have enough variants. No results produced by this region."
    fi
done
