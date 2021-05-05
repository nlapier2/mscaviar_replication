#!/bin/bash
# $ -S /bin/bash
# $ -N job-simulation_MsCaviar_nlapier2
# $ -cwd = run from this current working directory (relative paths)
# $ -o stdout-Simulation.out
# $ -l h_data=6G,h_rt=24:00:00
# $ -t 5-10:1
SGE_TASK_ID=1

source ~/.bash_profile
# source ~/.bashrc
. /u/local/Modules/default/init/modules.sh

#module load gsl/2.1
#module unload python
#module load python/anaconda3
#module load tmux
#module load plink
#module load intel/18.0.3
#module load zlib/1.2.11_gcc-4.9.3
#module load netcdf/4.7.0-c_gcc-4.9.3
#module load libpng/1.6.37_gcc-4.9.3
#module load R/3.4.0

#declare -i SGE_TASK_ID=1
this_num_causal=$1
this_heritability=$2
num_sim=$3
num_repeat=$4
sig_level=$5 # the lowerbound for the less significant study, testing 0, 3, and 5.2
sim_init_dir=$6 # the directory of simulation files
out_init_dir=$7 # output directory
input_bfile=$8
input_chrom=$9
#input_from_bp=$10
#input_to_bp=$11
pop1='ASN'
pop2='EURO1'
pop3='EURO2'
pop4='EUROs'

declare -i this_range_start=${SGE_TASK_ID}-1
declare -i this_range_end=${SGE_TASK_ID}

if [ ! -d ${sim_init_dir} ]
then
  mkdir ${sim_init_dir}
fi

if [ ! -d ${out_init_dir} ]
then
  mkdir ${out_init_dir}
fi

declare -i info=${SGE_TASK_ID}-1
echo ${out_init_dir}'_'${info}
mkdir ${sim_init_dir}/${info}
mkdir ${out_init_dir}/${info}

# Subsetting bfile by patient ID and SNP ranges (.bed files)
#plink --bfile /u/home/n/nlapier2/project-UKBB/data/cal/full_excld --keep /u/home/n/nlapier2/project-ukbiobank/data/mr_trio/chr1_2populations/from_helen/ALL.fam --chr 1 --from-mb $this_range_start --to-mb $this_range_end --make-bed --out ${sim_init_dir}/${info}/ALL_pop_chosen_loci
#plink --bfile /u/project/zarlab/nlapier2/mscaviar/sim_loci/high_ld_locus/thinned/snps_from_bgen_high_100kbp --keep /u/home/n/nlapier2/project-ukbiobank/data/mr_trio/chr1_2populations/from_helen/ALL.fam --chr 10 --from-mb $this_range_start --to-mb $this_range_end --make-bed --out ${sim_init_dir}/${info}/ALL_pop_chosen_loci
plink --bfile $8  --keep /u/home/n/nlapier2/project-ukbiobank/data/mr_trio/chr1_2populations/from_helen/ALL.fam --chr $9 --from-mb 0 --to-mb 999999 --make-bed --out ${sim_init_dir}/${info}/ALL_pop_chosen_loci


# Check if ALL_pop_chosen_loci.bed file exists (would not exist if all variants were filtered out)
if [ -f ${sim_init_dir}/${info}/ALL_pop_chosen_loci.bed ]
then
    plink --bfile ${sim_init_dir}/${info}/ALL_pop_chosen_loci --keep /u/home/n/nlapier2/project-ukbiobank/data/mr_trio/chr1_2populations/from_helen/ASN_1.fam --maf 0.05 --geno --make-bed --out ${sim_init_dir}/${info}/${pop1}
    plink --bfile ${sim_init_dir}/${info}/ALL_pop_chosen_loci --keep /u/home/n/nlapier2/project-ukbiobank/data/mr_trio/chr1_2populations/from_helen/EUR_1.fam --maf 0.05 --geno --make-bed --out ${sim_init_dir}/${info}/${pop2}
    plink --bfile ${sim_init_dir}/${info}/ALL_pop_chosen_loci --keep /u/home/n/nlapier2/project-ukbiobank/data/mr_trio/chr1_2populations/from_helen/EUR_2.fam --maf 0.05 --geno --make-bed --out ${sim_init_dir}/${info}/${pop3}
    plink --bfile ${sim_init_dir}/${info}/ALL_pop_chosen_loci --keep /u/home/n/nlapier2/project-ukbiobank/data/mr_trio/chr1_2populations/from_helen/EUROs.fam --maf 0.05 --geno --make-bed --out ${sim_init_dir}/${info}/${pop4}
    
    # Check if all of the .bim files exist (would not exist if all variants were filtered out by the maf and geno filters)
    if [ -f ${sim_init_dir}/${info}/${pop1}.bim -a -f ${sim_init_dir}/${info}/${pop2}.bim -a -f ${sim_init_dir}/${info}/${pop3}.bim ]
    then
        # Intersecting maf > 0.05 snps among all three populations (input: .bim, output: common.snps)
        Rscript /u/home/n/nlapier2/project-zarlab/mscaviar/test/helen_sims/Simulation/intersect_snps.R ${sim_init_dir}/${info}/${pop1}.bim ${sim_init_dir}/${info}/${pop2}.bim ${sim_init_dir}/${info}/${pop3}.bim ${sim_init_dir}/${info}/common.snps
        
        # Check if there are more than 10 snps and less than 200 snps in the common.snps file
        if [ `cat ${sim_init_dir}/${info}/common.snps | wc -l` -ge "10" -a `cat ${sim_init_dir}/${info}/common.snps | wc -l` -le "200" ]
        then
            plink --bfile ${sim_init_dir}/${info}/${pop1} --extract ${sim_init_dir}/${info}/common.snps --make-bed --out ${sim_init_dir}/${info}/${pop1}
            plink --bfile ${sim_init_dir}/${info}/${pop2} --extract ${sim_init_dir}/${info}/common.snps --make-bed --out ${sim_init_dir}/${info}/${pop2}
            plink --bfile ${sim_init_dir}/${info}/${pop3} --extract ${sim_init_dir}/${info}/common.snps --make-bed --out ${sim_init_dir}/${info}/${pop3}
            plink --bfile ${sim_init_dir}/${info}/${pop4} --extract ${sim_init_dir}/${info}/common.snps --make-bed --out ${sim_init_dir}/${info}/${pop4}
            
            # Running plink MAF calculation (.frq files)
#            plink --bfile ${sim_init_dir}/${info}/${pop1} --freq --out ${sim_init_dir}/${info}/${pop1}
#            plink --bfile ${sim_init_dir}/${info}/${pop2} --freq --out ${sim_init_dir}/${info}/${pop2}
#            plink --bfile ${sim_init_dir}/${info}/${pop3} --freq --out ${sim_init_dir}/${info}/${pop3}
#            plink --bfile ${sim_init_dir}/${info}/${pop4} --freq --out ${sim_init_dir}/${info}/${pop4}
            
            # Running plink LD calculation (.ld files)
            plink --bfile ${sim_init_dir}/${info}/${pop1} --r --matrix --out ${sim_init_dir}/${info}/${pop1}
            plink --bfile ${sim_init_dir}/${info}/${pop2} --r --matrix --out ${sim_init_dir}/${info}/${pop2}
            plink --bfile ${sim_init_dir}/${info}/${pop3} --r --matrix --out ${sim_init_dir}/${info}/${pop3}
            plink --bfile ${sim_init_dir}/${info}/${pop4} --r --matrix --out ${sim_init_dir}/${info}/${pop4}

            # Simulating beta to input to GCTA (.causal.snplist files)
             #python3 /u/home/n/nlapier2/project-zarlab/mscaviar/test/helen_sims/Simulation/simulate_GCTA_v1.py -c $this_num_causal -b1 ${sim_init_dir}/${info}/${pop1}.bim -s $num_repeat -o ${sim_init_dir}/${info} -l $sig_level
             python3 ../Simulation/simulate_GCTA_v1.py -c $this_num_causal -b1 ${sim_init_dir}/${info}/${pop1}.bim -s $num_repeat -o ${sim_init_dir}/${info} -l $sig_level -r ${sim_init_dir}/${info}/
   
            for j in $(seq 1 $num_repeat); do
                sim_dir=${sim_init_dir}/${info}/$j
                out_dir=${out_init_dir}/${info}/$j

                mkdir $sim_dir
                mkdir $out_dir

                # Running GCTA GWAS simulation of phenotypes (.phen files)
                /u/home/n/nlapier2/bin/gcta64 --bfile ${sim_init_dir}/${info}/${pop1}  --simu-qt --simu-hsq $this_heritability  --simu-causal-loci ${sim_init_dir}/${info}/${pop1}_${j}.causal.snplist  --simu-rep $num_sim --out ${sim_dir}/${pop1}_GWAS
                /u/home/n/nlapier2/bin/gcta64 --bfile ${sim_init_dir}/${info}/${pop2}  --simu-qt --simu-hsq $this_heritability  --simu-causal-loci ${sim_init_dir}/${info}/${pop2}_${j}.causal.snplist  --simu-rep $num_sim --out ${sim_dir}/${pop2}_GWAS
                /u/home/n/nlapier2/bin/gcta64 --bfile ${sim_init_dir}/${info}/${pop3}  --simu-qt --simu-hsq $this_heritability  --simu-causal-loci ${sim_init_dir}/${info}/${pop3}_${j}.causal.snplist  --simu-rep $num_sim --out ${sim_dir}/${pop3}_GWAS
                /u/home/n/nlapier2/bin/gcta64 --bfile ${sim_init_dir}/${info}/${pop4}  --simu-qt --simu-hsq $this_heritability  --simu-causal-loci ${sim_init_dir}/${info}/${pop4}_${j}.causal.snplist  --simu-rep $num_sim --out ${sim_dir}/${pop4}_GWAS
                    
                for k in $(seq 1 $num_sim); do
                    # Running GCTA solving for summary statistics (.fastGWA files)
                    /u/home/n/nlapier2/bin/gcta64 --bfile ${sim_init_dir}/${info}/${pop1}  --fastGWA-lr --pheno ${sim_dir}/${pop1}_GWAS.phen --mpheno $k --out ${sim_dir}/${pop1}_${k}
                    /u/home/n/nlapier2/bin/gcta64 --bfile ${sim_init_dir}/${info}/${pop2}  --fastGWA-lr --pheno ${sim_dir}/${pop2}_GWAS.phen --mpheno $k --out ${sim_dir}/${pop2}_${k}
                    /u/home/n/nlapier2/bin/gcta64 --bfile ${sim_init_dir}/${info}/${pop3}  --fastGWA-lr --pheno ${sim_dir}/${pop3}_GWAS.phen --mpheno $k --out ${sim_dir}/${pop3}_${k}
                    /u/home/n/nlapier2/bin/gcta64 --bfile ${sim_init_dir}/${info}/${pop4}  --fastGWA-lr --pheno ${sim_dir}/${pop4}_GWAS.phen --mpheno $k --out ${sim_dir}/${pop4}_${k}
                    
                    # Calculating zscores from summary statistics file (.caviar files)
                    python3 /u/home/n/nlapier2/project-zarlab/mscaviar/test/helen_sims/Simulation/format_sumstats.py --infile ${sim_dir}/${pop1}_${k}.fastGWA --outfile ${sim_dir}/${pop1}_${k}.caviar --chromosome CHR --bp POS --snp_id SNP --ref_allele A1 --alt_allele A2 --beta BETA --se SE
                    python3 /u/home/n/nlapier2/project-zarlab/mscaviar/test/helen_sims/Simulation/format_sumstats.py --infile ${sim_dir}/${pop2}_${k}.fastGWA --outfile ${sim_dir}/${pop2}_${k}.caviar --chromosome CHR --bp POS --snp_id SNP --ref_allele A1 --alt_allele A2 --beta BETA --se SE
                    python3 /u/home/n/nlapier2/project-zarlab/mscaviar/test/helen_sims/Simulation/format_sumstats.py --infile ${sim_dir}/${pop3}_${k}.fastGWA --outfile ${sim_dir}/${pop3}_${k}.caviar --chromosome CHR --bp POS --snp_id SNP --ref_allele A1 --alt_allele A2 --beta BETA --se SE
                    python3 /u/home/n/nlapier2/project-zarlab/mscaviar/test/helen_sims/Simulation/format_sumstats.py --infile ${sim_dir}/${pop4}_${k}.fastGWA --outfile ${sim_dir}/${pop4}_${k}.caviar --chromosome CHR --bp POS --snp_id SNP --ref_allele A1 --alt_allele A2 --beta BETA --se SE
                    
                    echo ${sim_init_dir}/${info}/${pop1}.ld > ${sim_dir}/ld_${k}.txt
                    echo ${sim_init_dir}/${info}/${pop2}.ld >> ${sim_dir}/ld_${k}.txt
                    echo ${sim_dir}/${pop1}_${k}.caviar > ${sim_dir}/gwas_${k}.txt
                    echo ${sim_dir}/${pop2}_${k}.caviar >> ${sim_dir}/gwas_${k}.txt
                    
#                    echo ${sim_init_dir}/${info}/${pop2}.ld > ${sim_dir}/ld_${k}_EUROs.txt
                    echo ${sim_init_dir}/${info}/${pop3}.ld >> ${sim_dir}/ld_${k}_EUROs.txt
                    echo ${sim_init_dir}/${info}/${pop2}.ld >> ${sim_dir}/ld_${k}_EUROs.txt
                    echo ${sim_dir}/${pop2}_${k}.caviar > ${sim_dir}/gwas_${k}_EUROs.txt
                    echo ${sim_dir}/${pop3}_${k}.caviar >> ${sim_dir}/gwas_${k}_EUROs.txt

                    # run MsCAVIAR and CAVIAR
                    MsCaviar_program="/u/project/zarlab/nlapier2/mscaviar/hdl/analysis_scripts/MsCAVIAR"
#                    MsCaviar_program="/u/home/h/helenhua/project-zarlab/MsCAVIAR_SIMULATIONS_NEW/Automation/MsCAVIAR"
                    $MsCaviar_program -l ${sim_dir}/ld_${k}.txt -z ${sim_dir}/gwas_${k}.txt -o ${out_dir}/mscaviar_${info}'_'$k -t 0.52 -c $this_num_causal -n 9000,9000 -a 0.0
                    $MsCaviar_program -l ${sim_dir}/ld_${k}_EUROs.txt -z ${sim_dir}/gwas_${k}_EUROs.txt -o ${out_dir}/mscaviar_${info}'_'$k'_EUROs' -t 0.52 -c $this_num_causal -n 9000,9000 -a 0.0
                    $MsCaviar_program -l ${sim_dir}/ld_${k}.txt -z ${sim_dir}/gwas_${k}.txt -o ${out_dir}/mscaviar_${info}'_'$k'_cutoff' -t 0.52 -c $this_num_causal -n 9000,9000 -a 0.01
                    $MsCaviar_program -l ${sim_dir}/ld_${k}_EUROs.txt -z ${sim_dir}/gwas_${k}_EUROs.txt -o ${out_dir}/mscaviar_${info}'_'$k'_EUROs_cutoff' -t 0.52 -c $this_num_causal -n 9000,9000 -a 0.01

                    /u/home/n/nlapier2/project-zarlab/mscaviar/test/helen_sims/Automation/CAVIAR -l ${sim_init_dir}/${info}/${pop1}.ld -z ${sim_dir}/${pop1}_${k}.caviar -o ${out_dir}/caviar_${pop1}${info}'_'$k -c $this_num_causal
                    /u/home/n/nlapier2/project-zarlab/mscaviar/test/helen_sims/Automation/CAVIAR -l ${sim_init_dir}/${info}/${pop2}.ld -z ${sim_dir}/${pop2}_${k}.caviar -o ${out_dir}/caviar_${pop2}${info}'_'$k -c $this_num_causal
                    /u/home/n/nlapier2/project-zarlab/mscaviar/test/helen_sims/Automation/CAVIAR -l ${sim_init_dir}/${info}/${pop3}.ld -z ${sim_dir}/${pop3}_${k}.caviar -o ${out_dir}/caviar_${pop3}${info}'_'$k -c $this_num_causal
#                    /u/home/h/helenhua/project-zarlab/MsCAVIAR_SIMULATIONS_NEW/Automation/CAVIAR -l ${sim_init_dir}/${info}/${pop2}.ld -z ${sim_dir}/${pop3}_${k}.caviar -o ${out_dir}/caviar_${pop3}${info}'_'$k -c $this_num_causal
                    /u/home/n/nlapier2/project-zarlab/mscaviar/test/helen_sims/Automation/CAVIAR -l ${sim_init_dir}/${info}/${pop4}.ld -z ${sim_dir}/${pop4}_${k}.caviar -o ${out_dir}/caviar_${pop4}${info}'_'$k -c $this_num_causal
                    
                    # for PAINTOR, fake annotate '0's for all locus
                    x=`wc -l ${sim_dir}/${pop1}_${k}.caviar | cut -d ' ' -f 1`
                    y=$(( x - 1))
                    echo "fake_annotate" > ${sim_dir}/paintor_${k}.txt
                    for i in $(seq 0 $y); do
                      echo "0" >> ${sim_dir}/paintor_${k}.txt
                    done
                    # for paintor, assemble multiple pops to the same file
                    echo 'pos zscore_pop1 pos zscore_pop2' > ${sim_dir}/bothpops_${k}.locus
                    paste ${sim_dir}/${pop1}_${k}.caviar ${sim_dir}/${pop2}_${k}.caviar >> ${sim_dir}/bothpops_${k}.locus
                    # replace tab with space and reformat files
                    sed -i 's/\t/ /g' ${sim_dir}/bothpops_${k}.locus
                    cp ${sim_init_dir}/${info}/${pop1}.ld ${sim_dir}/bothpops_${k}.locus.pop1LD
                    cp ${sim_init_dir}/${info}/${pop2}.ld ${sim_dir}/bothpops_${k}.locus.pop2LD
                    mv ${sim_dir}/paintor_${k}.txt ${sim_dir}/bothpops_${k}.locus.annotations
                    echo "bothpops_${k}.locus" > ${sim_dir}/infiles_paintor_${k}.txt
                    if [ ! -d ${out_dir}/PAINTOR_${this_num_causal}/ ]
                    then
                      mkdir ${out_dir}/PAINTOR_${this_num_causal}/
                    fi

                    # run PAINTOR
                    /u/home/n/nlapier2/project-zarlab/mscaviar/test/helen_sims/Automation/PAINTOR -input ${sim_dir}/infiles_paintor_${k}.txt -in ${sim_dir}/ -out ${out_dir}/PAINTOR_${this_num_causal}/ -Zhead zscore_pop1,zscore_pop2 -LDname pop1LD,pop2LD -annotations fake_annotate -enumerate $this_num_causal

                    # analyze accuracy and set size
                    mscaviar_result=${out_dir}/'mscaviar_'${info}'_'$k'_set.txt'
                    mscaviar_result_EUROs=${out_dir}/'mscaviar_'${info}'_'$k'_EUROs_set.txt'
                    mscaviar_result_cutoff=${out_dir}/'mscaviar_'${info}'_'$k'_cutoff_set.txt'
                    mscaviar_result_EUROs_cutoff=${out_dir}/'mscaviar_'${info}'_'$k'_EUROs_cutoff_set.txt'
                    python3 /u/home/n/nlapier2/project-zarlab/mscaviar/test/helen_sims/Automation/capture.py -s1 $mscaviar_result -t ${sim_init_dir}/${info}/${pop1}_${j}.causal.snplist -p ${out_init_dir}/${info}/'R_mscaviar_'${info} -w mscaviar
                    python3 /u/home/n/nlapier2/project-zarlab/mscaviar/test/helen_sims/Automation/capture.py -s1 $mscaviar_result_EUROs -t ${sim_init_dir}/${info}/${pop1}_${j}.causal.snplist -p ${out_init_dir}/${info}/'R_mscaviar_'${info}'_EUROs' -w mscaviar
                    python3 /u/home/n/nlapier2/project-zarlab/mscaviar/test/helen_sims/Automation/capture.py -s1 $mscaviar_result_cutoff -t ${sim_init_dir}/${info}/${pop1}_${j}.causal.snplist -p ${out_init_dir}/${info}/'R_mscaviar_'${info}'_cutoff' -w mscaviar
                    python3 /u/home/n/nlapier2/project-zarlab/mscaviar/test/helen_sims/Automation/capture.py -s1 $mscaviar_result_EUROs_cutoff -t ${sim_init_dir}/${info}/${pop1}_${j}.causal.snplist -p ${out_init_dir}/${info}/'R_mscaviar_'${info}'_EUROs_cutoff' -w mscaviar

                    caviar_result1=${out_dir}/'caviar_'${pop1}${info}'_'$k'_set'
                    caviar_result2=${out_dir}/'caviar_'${pop2}${info}'_'$k'_set'
                    caviar_result3=${out_dir}/'caviar_'${pop3}${info}'_'$k'_set'
                    caviar_result4=${out_dir}/'caviar_'${pop4}${info}'_'$k'_set'
                    python3 /u/home/n/nlapier2/project-zarlab/mscaviar/test/helen_sims/Automation/capture.py -s1 $caviar_result1 -s2 $caviar_result2 -s3 $caviar_result3 -s4 $caviar_result4 -t ${sim_init_dir}/${info}/${pop1}_${j}.causal.snplist -p ${out_init_dir}/${info}/'R_caviar_'${info} -w caviar
                    paintor_result=${out_dir}/'paintor_'${info}'_'$k'_set.txt'
                    Rscript /u/home/n/nlapier2/project-zarlab/mscaviar/test/helen_sims/Automation/paintor.R ${out_dir}/PAINTOR_${this_num_causal}/bothpops_${k}.locus.results ${sim_init_dir}/${info}/${pop1}_${j}.causal.snplist 0.95 ${out_init_dir}/${info}/'R_paintor_'${info}'_recall_rate.txt' ${out_init_dir}/${info}/'R_paintor_'${info}'_config_size.txt'
                    
                    # for susie, generate file names
                    susie_result1=${out_dir}/'susie_'${pop1}${info}'_'$k'_set.txt'
                    susie_result2=${out_dir}/'susie_'${pop2}${info}'_'$k'_set.txt'

                    susie_subsets_result1=${out_dir}/'susie_'${pop1}${info}'_'$k'_subsets.txt'
                    susie_subsets_result2=${out_dir}/'susie_'${pop2}${info}'_'$k'_subsets.txt'

                    susie_subsets_result1=${out_dir}/'susie_'${pop1}${info}'_'$k'_subsets.txt'
                    susie_subsets_result2=${out_dir}/'susie_'${pop2}${info}'_'$k'_subsets.txt'

                    susie_unionset_result1=${out_dir}/'susie_'${pop1}${info}'_'$k'_set.txt'
                    susie_unionset_result2=${out_dir}/'susie_'${pop2}${info}'_'$k'_set.txt'

                    # run SuSiE
                    Rscript /u/home/n/nlapier2/project-zarlab/mscaviar/test/helen_sims/Automation/susie2.R ${sim_dir}/${pop1}_${k}.caviar ${sim_init_dir}/${info}/${pop1}.ld ${sim_init_dir}/${info}/${pop1}_${j}.causal.snplist $this_num_causal $susie_subsets_result1 $susie_unionset_result1 ${out_init_dir}/${info}/'R_susie_'${pop1}'_'${info}'_recall_rate.txt' ${out_init_dir}/${info}/'R_susie_'${pop1}'_'${info}'_config_size.txt' ${out_init_dir}/${info}/'R_susie_'${pop1}'_'${info}'_num_CS.txt'
                    Rscript /u/home/n/nlapier2/project-zarlab/mscaviar/test/helen_sims/Automation/susie2.R ${sim_dir}/${pop2}_${k}.caviar ${sim_init_dir}/${info}/${pop2}.ld ${sim_init_dir}/${info}/${pop2}_${j}.causal.snplist $this_num_causal $susie_subsets_result2 $susie_unionset_result2 ${out_init_dir}/${info}/'R_susie_'${pop2}'_'${info}'_recall_rate.txt' ${out_init_dir}/${info}/'R_susie_'${pop2}'_'${info}'_config_size.txt' ${out_init_dir}/${info}/'R_susie_'${pop2}'_'${info}'_num_CS.txt'
                    
                done
            done
        else
        echo "Not enough / too much variants (fewer than 10 or greater than 200 snps) in this region"${info}". Session aborted."
        fi
    else
    echo "Not enough variants after maf and geno filters. Session aborted."
    fi
else
echo ${sim_init_dir}/${info}/ALL_pop_chosen_loci.bed" cannot be created (lack of variants)!!! Session aborted."
fi

