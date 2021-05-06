## Scripts for Simulation Studies
There are 2 sub-directories: Simulation/ and Automation/

Simulation/ includes _simulate_GCTA_v1.py_, which randomly select snps in the designated regions and generate a beta based on the population size and significance level. _format_sumstats.py_ would calculate zscores from the output of GCTA’s fastGWAS.

Automation/ includes _MsCAVIAR_simulation.sh_, which is a shell script that connects all the scripts and softwares together. _capture.py_ would capture the results of Caviar and MsCaviar, comparing them to the supposed results and calculate the set sizes and recall rates. paintor.R does the same for PAINTOR. susie2.R runs SuSiE and capture the results the same way as other methods. _MsCAVIAR_summary_results.sh_ is a convenient script that concatenate results from every region and every method to one file to make it easier open in Excel or R. _pip_precision_recall.py_ calculate the average number of SNPs with top posterior inclusion probability until causal SNPs are identified.

Finally, in the main directory, there are 3 visualization R scripts, which generate figure 2A (_plot_accuracy_together.R_), 2B (_plot_setSize_together.R_), and 2C (_plot_PIP.R_) in our manuscript.

### Main simulation workflow in _MsCAVIAR_simulation.sh_:
* Select patient ID by their ethnicity for each population -- ASN, EURO1, and EURO2 (_subset_sample.py_, _id_to_ethnicity.csv_)
* Use plink to subset UKBB genotype bfile by patient ID and SNP ranges
* Run plink LD calculation
* Simulate beta to input to GCTA (_simulate_GCTA_v1.py_)
* Simulate phenotypes using GCTA's GWAS simulation
* Do linear regression on simulated studies using GCTA's fastGWA
* Calculating zscores from summary statistics file (_format_sumstats.py_)
* Run each finemapping software (see below)
* Capture sensitivity and set size (_capture.py_)

### Finemapping softwares being evaluated in this simulation:
(Corresponnding executables and scripts are included in the Automation/ directory.)
* CAVIAR
* MsCAVIAR
* PAINTOR
* susie2.R
