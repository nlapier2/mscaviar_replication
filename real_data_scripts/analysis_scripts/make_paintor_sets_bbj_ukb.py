# A helper script to make credible sets from PAINTOR posterior probabilities
import glob, os, subprocess

__location__ = os.path.realpath(os.path.join(os.getcwd(), os.path.dirname(__file__))) + '/'
paintor_exec = __location__ + 'PAINTOR'
pipeline_outdir = __location__ + '../loci_win500kb_minpeakZ5pt2_minsnpZ1pt96_min10snp/'
results_dir = pipeline_outdir + 'results/'
locus_dirs = next(os.walk(pipeline_outdir))[1]
unpruned_locus_dirs = [pipeline_outdir + i + '/' for i in locus_dirs if i != 'results']
pruned_locus_dirs = [pipeline_outdir + i + '/pruned/' for i in locus_dirs if i != 'results']

threshold = 0.95
for ldir in pruned_locus_dirs:  # picked_locus_dirs:
	paintor_res_file = glob.glob(ldir + 'paintor.results')[0]
	snp_to_prob, picked_snps = [], []
	with(open(paintor_res_file, 'r')) as infile:
		header = infile.readline()
		for line in infile:
			splits = line.strip().split(' ')
			rsid, prob = splits[2], float(splits[-1])
			snp_to_prob.append([rsid, prob])
	sum_probs = sum([i[1] for i in snp_to_prob])
	snp_to_prob.sort(key = lambda x: x[1], reverse=True)
	running_total, index = 0.0, 0
	while running_total < sum_probs * threshold:
		picked_snps.append(snp_to_prob[index][0])
		running_total += snp_to_prob[index][1]
		index += 1
		if index == len(snp_to_prob):
			break
	final_fname = results_dir + 'paintor_results_' + ldir.split(
		pipeline_outdir)[1].split('/pruned/')[0] + '.txt'
	with(open(final_fname, 'w')) as outfile:
		for snp in picked_snps:
			outfile.write(snp + '\n')


for ldir in unpruned_locus_dirs:  # picked_locus_dirs:
	paintor_res_file = glob.glob(ldir + 'paintor.results')[0]
	snp_to_prob, picked_snps = [], []
	with(open(paintor_res_file, 'r')) as infile:
		header = infile.readline()
		for line in infile:
			splits = line.strip().split(' ')
			rsid, prob = splits[2], float(splits[-1])
			snp_to_prob.append([rsid, prob])
	sum_probs = sum([i[1] for i in snp_to_prob])
	snp_to_prob.sort(key = lambda x: x[1], reverse=True)
	running_total, index = 0.0, 0
	while running_total < sum_probs * threshold:
		picked_snps.append(snp_to_prob[index][0])
		running_total += snp_to_prob[index][1]
		index += 1
		if index == len(snp_to_prob):
			break
	final_fname = results_dir + 'unpruned_paintor_results_' + ldir.split(
		pipeline_outdir)[1].split('/')[0] + '.txt'
	with(open(final_fname, 'w')) as outfile:
		for snp in picked_snps:
			outfile.write(snp + '\n')
#

