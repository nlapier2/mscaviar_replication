# Expected input format example: a file with
"""
rs123 rs789
mscaviar mscaviar_pips_locus_1.txt
paintor paintor_pips_locus_1.txt
caviar caviar_pips_locus_1.txt

rs321 rs987
mscaviar mscaviar_pips_locus_2.txt
paintor paintor_pips_locus_2.txt
caviar caviar_pips_locus_2.txt
"""
# where the first line is a space-separated list of causal snps
#     and subsequent lines are method name, space, filname for file containing method's PIPs
#     and there is a blank line in between the details for different loci
#
# if the above file is called "locus_info.txt", then run this script like
#     "python pip_precision_recall.py locus_info.txt"
# NOTE: this script assumes that the methods and number of causal snps are the same across all loci


import sys
import pandas as pd
import numpy as np


# read input file of format described above into a list of dicts containing the information for each locus
def read_infile(fname):
	locus_info = []
	locus = {}
	with(open(fname, 'r')) as infile:
		for line in infile:
			if line.strip() == '':  # blank line
				locus_info.append(locus)
				locus = {}
			else:
				splits = line.strip().split(' ')
				if len(locus) == 0:
					locus['causal_snp_list'] = splits
				else:
					method_name, fname = splits[0], splits[1]
					locus[method_name] = fname
	if len(locus) != 0:
		locus_info.append(locus)
	return locus_info


# for a given file with a method's PIPs for the SNPs, read that information in and sort the SNPs by descending PIP
def read_snps_and_sort_pips(fname, method_name):
	if 'aintor' in method_name:
		paintor = True
	else:
		paintor = False
	snp_to_pip = []
	with(open(fname, 'r')) as infile:
		infile.readline()  # skip header
		for line in infile:
			if paintor:
				splits = line.strip().split(' ')
				snp, pip = splits[2], float(splits[-1])
			else:
				splits = line.strip().split('\t')
				snp, pip = splits[0], float(splits[1])
			snp_to_pip.append([snp, pip])
	snp_to_pip.sort(key=lambda x: x[1], reverse=True)
	return snp_to_pip


# compute the number of total snps taken into the causal set until each number of causal snps is reached
# for instance if the pip-ordered snps are causal,non-causal,non-causal,causal and there are two total causal snps,
#   the output would be [1, 4] since you take 1 total snp to get one causal snp and two total snps to get both causals
def compute_false_and_true_pos(snps_with_pips, causal_snp_list):
	total_snp_until_causals = []
	snp_count = 0
	for i in range(len(snps_with_pips)):
		snp_count += 1
		if snps_with_pips[i][0] in causal_snp_list:
			total_snp_until_causals.append(snp_count)
			if len(total_snp_until_causals) == len(causal_snp_list):  # all causal snps now found
				break
	return total_snp_until_causals


# run compute_false_and_true_pos (see above) for each method for a locus
def get_results_for_locus(locus_info):
	locus_results = {}
	for method_name in locus_info:
		if method_name == 'causal_snp_list':
			continue
		fname = locus_info[method_name]
		snp_to_pip = read_snps_and_sort_pips(fname, method_name)
		locus_results[method_name] = compute_false_and_true_pos(snp_to_pip, locus_info['causal_snp_list'])
	return locus_results


def main():
	infile = sys.argv[1]
	locus_info = read_infile(infile)
	num_loci = len(locus_info)

	# gather and average the results over all loci
	results = {}
	for i in range(num_loci):
		locus_results = get_results_for_locus(locus_info[i])
		if len(results) == 0:  # first locus processed
			results = locus_results
		else:
			for method in results:
				for j in range(len(results[method])):
					results[method][j] += locus_results[method][j]  # running total of results
	for method in results:
		for i in range(len(results[method])):
			results[method][i] = round(results[method][i] / float(num_loci), 3)  # average over all loci

	# print the output in a pandas dataframe to make it look cleaner
	df = pd.DataFrame(results)
	df.index = np.arange(1, len(df) + 1)  # 1-index rows so they indicate num_causal
	print(df)


if __name__ == '__main__':
	main()
