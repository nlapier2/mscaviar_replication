### Scripts for Real Data Analysis

We obtained summary statitistics for High Density Lipoprotein (HDL) GWAS from the UK Biobank and Biobank Japan -- see data_sources.txt for links and citations. These files were much too large to include in this repository. Thus, to replicate our results, you will need to pull the GWAS statistics yourself. 

The analysis_scripts/ directory includes the scripts used to perform all analyses as well as the method binaries, and the "submit" scripts contain the commands used to run the methods on our server. Please note that the pre-compiled method binaries may not work on your system.

First, we ran analysis_scripts/format_sumstats.py to reformat the downloaded summary statistics for easy processing by the subsequent scripts. We placed these reformatted sumstats in the reformatted_sumstats/ folder (not shown here as, again, the files were too large to include).

We then ran submit_pipeline.sh to generate all of the loci and input files for the methods, while making sure that only SNPs present in both data sets were used. For the details on how loci were picked, please see the MsCAVIAR paper. This script also performed LD pruning, which was not ultimately used in the paper, and ran MsCAVIAR, which was later commented out because we wanted to profile the runtime of MsCAVIAR by running it separately. 

The pipeline consists of running the following scripts in analysis_scripts, whose names indicate their function: sumstats_mscaviar_pipeline.py, pick_loci.py, generate_ld_and_mscaviar_files.py, reconcile_studies.py (making sure only SNPs present in all studies are used), and ld_prune.py. 

The pipeline script also makes use of a helper script from PAINTOR to generate 1000 genomes LD matrices, which can be obtained from the PAINTOR repository: https://github.com/gkichaev/PAINTOR_V3.0/blob/master/PAINTOR_Utilities/CalcLD_1KG_VCF.py. PAINTOR's repository also helpfully explains how that works: https://github.com/gkichaev/PAINTOR_V3.0/wiki/2a.-Computing-1000-genomes-LD.

We then used submit_caviar.sh, submit_mscaviar.sh, and submit_paintor.sh to run the methods on these generated loci.

