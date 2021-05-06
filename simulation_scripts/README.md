### Scripts for Simulation Studies
There are 2 sub-directories: Simulation/ and Automation/

Simulation/ includes _simulate_GCTA_v1.py_, which randomly select snps in the designated regions and generate a beta based on the population size and significance level. _format_sumstats.py_ would calculate zscores from the output of GCTA’s fastGWAS.
Automation/ includes _MsCAVIAR_simulation.sh_, which is a shell script that connects all the scripts and softwares together. The documentation should be pretty clear for each steps. capture.py  would capture the results of Caviar and MsCaviar, comparing them to the supposed results and calculate the set sizes and recall rates. paintor.R does the same for PAINTOR. susie2.R runs SuSiE and capture the results the same way as other methods.  MsCAVIAR_summary_results.sh  is just a convenient script that concatenate results from every region and every method to one file to make it easier for me to open them in Excel or R.

# Methods being evaluated in the simulation includes:
* CAVIAR
* MsCAVIAR
* PAINTOR
* susie2.R
