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
out_init_dir=$2 # output directory
pop1='ASN'
pop2='EURO1'
pop3='EURO2'
pop4='EUROs'

S_MsCAVIAR_recall=${out_init_dir}/'R_mscaviar_recall_rate.txt'
S_MsCAVIAR_size=${out_init_dir}/'R_mscaviar_config_size.txt'
S_MsCAVIAR_EUROs_recall=${out_init_dir}/'R_mscaviar_EUROs_recall_rate.txt'
S_MsCAVIAR_EUROs_size=${out_init_dir}/'R_mscaviar_EUROs_config_size.txt'

S_MsCAVIAR_cutoff_recall=${out_init_dir}/'R_mscaviar_cutoff_recall_rate.txt'
S_MsCAVIAR_cutoff_size=${out_init_dir}/'R_mscaviar_cutoff_config_size.txt'
S_MsCAVIAR_EUROs_cutoff_recall=${out_init_dir}/'R_mscaviar_EUROs_cutoff_recall_rate.txt'
S_MsCAVIAR_EUROs_cutoff_size=${out_init_dir}/'R_mscaviar_EUROs_cutoff_config_size.txt'

S_CAVIAR_pop1_recall=${out_init_dir}/'R_caviar_'${pop1}'_recall_rate.txt'
S_CAVIAR_pop1_size=${out_init_dir}/'R_caviar_'${pop1}'_config_size.txt'
S_CAVIAR_pop2_recall=${out_init_dir}/'R_caviar_'${pop2}'_recall_rate.txt'
S_CAVIAR_pop2_size=${out_init_dir}/'R_caviar_'${pop2}'_config_size.txt'
S_CAVIAR_pop3_recall=${out_init_dir}/'R_caviar_'${pop3}'_recall_rate.txt'
S_CAVIAR_pop3_size=${out_init_dir}/'R_caviar_'${pop3}'_config_size.txt'
S_CAVIAR_pop4_recall=${out_init_dir}/'R_caviar_'${pop4}'_recall_rate.txt'
S_CAVIAR_pop4_size=${out_init_dir}/'R_caviar_'${pop4}'_config_size.txt'
S_PAINTOR_recall=${out_init_dir}/'R_paintor_recall_rate.txt'
S_PAINTOR_size=${out_init_dir}/'R_paintor_config_size.txt'
S_SuSiE_pop1_recall=${out_init_dir}/'R_susie_'${pop1}'_recall_rate.txt'
S_SuSiE_pop1_size=${out_init_dir}/'R_susie_'${pop1}'_config_size.txt'
S_SuSiE_pop2_recall=${out_init_dir}/'R_susie_'${pop2}'_recall_rate.txt'
S_SuSiE_pop2_size=${out_init_dir}/'R_susie_'${pop2}'_config_size.txt'

for i in $(seq 1 $SGE_TASK_ID); do
    declare -i info=$i-1

    MsCAVIAR_recall=${out_init_dir}/${info}/'R_mscaviar_'${info}'_recall_rate.txt'
    MsCAVIAR_size=${out_init_dir}/${info}/'R_mscaviar_'${info}'_config_size.txt'
    MsCAVIAR_EUROs_recall=${out_init_dir}/${info}/'R_mscaviar_'${info}'_EUROs_recall_rate.txt'
    MsCAVIAR_EUROs_size=${out_init_dir}/${info}/'R_mscaviar_'${info}'_EUROs_config_size.txt'

    MsCAVIAR_cutoff_recall=${out_init_dir}/${info}/'R_mscaviar_'${info}'_cutoff_recall_rate.txt'
    MsCAVIAR_cutoff_size=${out_init_dir}/${info}/'R_mscaviar_'${info}'_cutoff_config_size.txt'
    MsCAVIAR_EUROs_cutoff_recall=${out_init_dir}/${info}/'R_mscaviar_'${info}'_EUROs_cutoff_recall_rate.txt'
    MsCAVIAR_EUROs_cutoff_size=${out_init_dir}/${info}/'R_mscaviar_'${info}'_EUROs_cutoff_config_size.txt'

    CAVIAR_pop1_recall=${out_init_dir}/${info}/'R_caviar_'${info}'_'${pop1}'_recall_rate.txt'
    CAVIAR_pop1_size=${out_init_dir}/${info}/'R_caviar_'${info}'_'${pop1}'_config_size.txt'
    CAVIAR_pop2_recall=${out_init_dir}/${info}/'R_caviar_'${info}'_'${pop2}'_recall_rate.txt'
    CAVIAR_pop2_size=${out_init_dir}/${info}/'R_caviar_'${info}'_'${pop2}'_config_size.txt'
    CAVIAR_pop3_recall=${out_init_dir}/${info}/'R_caviar_'${info}'_'${pop3}'_recall_rate.txt'
    CAVIAR_pop3_size=${out_init_dir}/${info}/'R_caviar_'${info}'_'${pop3}'_config_size.txt'
    CAVIAR_pop4_recall=${out_init_dir}/${info}/'R_caviar_'${info}'_'${pop4}'_recall_rate.txt'
    CAVIAR_pop4_size=${out_init_dir}/${info}/'R_caviar_'${info}'_'${pop4}'_config_size.txt'
    PAINTOR_recall=${out_init_dir}/${info}/'R_paintor_'${info}'_recall_rate.txt'
    PAINTOR_size=${out_init_dir}/${info}/'R_paintor_'${info}'_config_size.txt'
    SuSiE_pop1_recall=${out_init_dir}/${info}/'R_susie_'${pop1}'_'${info}'_recall_rate.txt'
    SuSiE_pop1_size=${out_init_dir}/${info}/'R_susie_'${pop1}'_'${info}'_config_size.txt'
    SuSiE_pop2_recall=${out_init_dir}/${info}/'R_susie_'${pop2}'_'${info}'_recall_rate.txt'
    SuSiE_pop2_size=${out_init_dir}/${info}/'R_susie_'${pop2}'_'${info}'_config_size.txt'
    
#    wc -l $MsCAVIAR_recall
    if [ -f $MsCAVIAR_recall ]
    then
        cat $MsCAVIAR_recall >> $S_MsCAVIAR_recall
        cat $MsCAVIAR_size >> $S_MsCAVIAR_size
        cat $MsCAVIAR_EUROs_recall >> $S_MsCAVIAR_EUROs_recall
        cat $MsCAVIAR_EUROs_size >> $S_MsCAVIAR_EUROs_size

        cat $MsCAVIAR_cutoff_recall >> $S_MsCAVIAR_cutoff_recall
        cat $MsCAVIAR_cutoff_size >> $S_MsCAVIAR_cutoff_size
        cat $MsCAVIAR_EUROs_cutoff_recall >> $S_MsCAVIAR_EUROs_cutoff_recall
        cat $MsCAVIAR_EUROs_cutoff_size >> $S_MsCAVIAR_EUROs_cutoff_size

        cat $CAVIAR_pop1_recall >> $S_CAVIAR_pop1_recall
        cat $CAVIAR_pop1_size >> $S_CAVIAR_pop1_size
        cat $CAVIAR_pop2_recall >> $S_CAVIAR_pop2_recall
        cat $CAVIAR_pop2_size >> $S_CAVIAR_pop2_size
        cat $CAVIAR_pop3_recall >> $S_CAVIAR_pop3_recall
        cat $CAVIAR_pop3_size >> $S_CAVIAR_pop3_size
        cat $CAVIAR_pop4_recall >> $S_CAVIAR_pop4_recall
        cat $CAVIAR_pop4_size >> $S_CAVIAR_pop4_size
        cat $PAINTOR_recall >> $S_PAINTOR_recall
        cat $PAINTOR_size >> $S_PAINTOR_size
        cat $SuSiE_pop1_recall >> $S_SuSiE_pop1_recall
        cat $SuSiE_pop1_size >> $S_SuSiE_pop1_size
        cat $SuSiE_pop2_recall >> $S_SuSiE_pop2_recall
        cat $SuSiE_pop2_size >> $S_SuSiE_pop2_size
    else
    echo "Region "${info}" did not have enough variants. No results produced by this region."
    fi

done

echo -e 'MsCAVIAR_recall\tMsCAVIAR_EUROs_recall\tMsCAVIAR_cutoff_recall\tMsCAVIAR_EUROs_cutoff_recall\tCAVIAR_pop1_recall\tCAVIAR_pop2_recall\tCAVIAR_pop3_recall\tCAVIAR_pop4_recall\tPAINTOR_recall\tSuSiE_pop1_recall\tSuSiE_pop2_recall' > ${out_init_dir}/'Recall_rate.txt'
paste $S_MsCAVIAR_recall $S_MsCAVIAR_EUROs_recall $S_MsCAVIAR_cutoff_recall $S_MsCAVIAR_EUROs_cutoff_recall $S_CAVIAR_pop1_recall $S_CAVIAR_pop2_recall $S_CAVIAR_pop3_recall $S_CAVIAR_pop4_recall $S_PAINTOR_recall $S_SuSiE_pop1_recall $S_SuSiE_pop2_recall >> ${out_init_dir}/'Recall_rate.txt'

echo -e 'MsCAVIAR_size\tMsCAVIAR_EUROs_size\tMsCAVIAR_cutoff_size\tMsCAVIAR_EUROs_cutoff_size\tCAVIAR_pop1_size\tCAVIAR_pop2_size\tCAVIAR_pop3_size\tCAVIAR_pop4_size\tPAINTOR_size\tSuSiE_pop1_size\tSuSiE_pop2_size' > ${out_init_dir}/'Set_size.txt'
paste $S_MsCAVIAR_size $S_MsCAVIAR_EUROs_size $S_MsCAVIAR_cutoff_size $S_MsCAVIAR_EUROs_cutoff_size $S_CAVIAR_pop1_size $S_CAVIAR_pop2_size $S_CAVIAR_pop3_size $S_CAVIAR_pop4_size $S_PAINTOR_size $S_SuSiE_pop1_size $S_SuSiE_pop2_size >> ${out_init_dir}/'Set_size.txt'
