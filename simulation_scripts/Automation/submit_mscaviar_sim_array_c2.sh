#!/bin/sh
#$ -S /bin/bash  # run in a bash shell
#$ -N job-c2-sim-mscaviar-array_nlapier2  # this is the (N)ame of your job
#$ -cwd  # this (c)hanges the (w)orking (d)irectory to the directory with this script
#$ -o stdout-c2-sim-mscaviar-array.out  # this is the file that standard (o)utput will be written to
#$ -l h_data=16G,highp,h_rt=2:00:00  # request 16 (G)igabytes of memory and 2 hours of compute time for the job
#$ -t 1-15:1  # run an array job, with job numbers ranging from 1 to 15 in increments of 1

. /u/local/Modules/default/init/modules.sh  # allows you to load modules
source ~/.bash_profile  # load your account settings stored in your bash profile

#h2=(0.001 0.0025 0.005 0.0075 0.01 0.025 0.05 0.075 0.1)
h2=(0.004 0.008 0.012 0.016 0.02)
ld=('high' 'medium' 'low')
index=$((${SGE_TASK_ID}-1))
h2_index=$((${index}%${#h2[@]}))
ld_index=$((${index}/${#h2[@]}))
this_h2=${h2[$h2_index]}
this_ld=${ld[$ld_index]}

if [ "$this_ld" = 'high' ]; then
    #./MsCAVIAR_simulation.sh 2 $this_h2 1 10 5.2 ../Simulation/multi_test/causal_2_ld_high_h2_$this_h2 ../Simulation/multi_test/causal_2_ld_high_h2_$this_h2/out /u/project/zarlab/nlapier2/mscaviar/sim_loci/high_ld_locus/thinned/snps_from_bgen_high_100kbp 10
    ./MsCAVIAR_simulation.sh 2 $this_h2 1 20 5.2 ../Simulation/r_no_neg_test/causal_2_ld_high_h2_$this_h2 ../Simulation/r_no_neg_test/causal_2_ld_high_h2_$this_h2/out /u/project/zarlab/nlapier2/mscaviar/sim_loci/high_ld_locus/thinned/snps_from_bgen_high_100kbp 10
fi

if [ "$this_ld" = 'medium' ]; then
    #./MsCAVIAR_simulation.sh 2 $this_h2 1 10 5.2 ../Simulation/multi_test/causal_2_ld_medium_h2_$this_h2 ../Simulation/multi_test/causal_2_ld_medium_h2_$this_h2/out /u/project/zarlab/nlapier2/mscaviar/sim_loci/medium_ld_locus/thinned/snps_from_bgen_medium_100kbp 11
    ./MsCAVIAR_simulation.sh 2 $this_h2 1 20 5.2 ../Simulation/r_no_neg_test/causal_2_ld_medium_h2_$this_h2 ../Simulation/r_no_neg_test/causal_2_ld_medium_h2_$this_h2/out /u/project/zarlab/nlapier2/mscaviar/sim_loci/medium_ld_locus/thinned/snps_from_bgen_medium_100kbp 11
fi

if [ "$this_ld" = 'low' ]; then
    #./MsCAVIAR_simulation.sh 2 $this_h2 1 10 5.2 ../Simulation/multi_test/causal_2_ld_low_h2_$this_h2 ../Simulation/multi_test/causal_2_ld_low_h2_$this_h2/out /u/project/zarlab/nlapier2/mscaviar/sim_loci/low_ld_locus/thinned/snps_from_bgen_low_100kbp 10
    ./MsCAVIAR_simulation.sh 2 $this_h2 1 20 5.2 ../Simulation/r_no_neg_test/causal_2_ld_low_h2_$this_h2 ../Simulation/r_no_neg_test/causal_2_ld_low_h2_$this_h2/out /u/project/zarlab/nlapier2/mscaviar/sim_loci/low_ld_locus/thinned/snps_from_bgen_low_100kbp 10
fi
#
