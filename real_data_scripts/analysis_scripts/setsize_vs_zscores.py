import glob, os, subprocess

__location__ = os.path.realpath(os.path.join(os.getcwd(), os.path.dirname(__file__))) + '/'
pipeline_outdir = __location__ + '../loci_minpeakZ5pt2_minsnpZ3pt9_min10snp/'
results_dir = pipeline_outdir + 'results/'
locus_dirs = next(os.walk(pipeline_outdir))[1]
locus_dirs = [pipeline_outdir + i + '/pruned/' for i in locus_dirs if i != 'results']

# all_loci_info: 2d list. one list per locus with:
#    [bbj peak Zscore, ukb peak Zscore, ratio, # SNPs, mscaviar set size, paintor set size,
#        mscaviar/paintor set size ratio, cav_bbj_set_size, cav_ukb_set_size]
all_loci_info = []
for ldir in locus_dirs:
	locus_info = [0.0, 0.0, 0.0, 0, 0, 0, 0.0, 0, 0]
	bbj_fname, ukb_fname = glob.glob(ldir + '*bbj*.zscores')[0], glob.glob(ldir + '*ukb*.zscores')[0]
	with(open(bbj_fname, 'r')) as b_infile:
		with(open(ukb_fname, 'r')) as u_infile:
			line_count, max_val, other_val, max_study = 0, 0, 0, ''
			for bline in b_infile:
				bsplits = bline.strip().split()
				usplits = u_infile.readline().strip().split()
				b_z, u_z = abs(float(bsplits[-1])), abs(float(usplits[-1]))
				if b_z >= max_val and b_z >= u_z:
					max_val = b_z
					other_val = u_z
					max_study = 'bbj'
				elif u_z >= max_val and u_z >= b_z:
					max_val = u_z
					other_val = b_z
					max_study = 'ukb'
				line_count += 1
			if max_study == 'bbj':  # BBJ Z is max value
				locus_info[:3] = max_val, other_val, other_val / max_val
			else:  # UKB Z is max val
				locus_info[:3] = other_val, max_val, max_val / other_val
			locus_info[3] = line_count

			locus_name = ldir.split(pipeline_outdir)[1].split('/pruned/')[0]
			mscaviar_out = results_dir + 'mscaviar_results_' + locus_name + '_set.txt'
			paintor_out = results_dir + 'paintor_results_' + locus_name + '.txt'
			p = subprocess.Popen(['wc', '-l', mscaviar_out], stdout=subprocess.PIPE)
			out, err = p.communicate()
			mscaviar_set_size = int(out.split()[0])
			locus_info[4] = mscaviar_set_size
			p = subprocess.Popen(['wc', '-l', paintor_out], stdout=subprocess.PIPE)
			out, err = p.communicate()
			paintor_set_size = int(out.split()[0])
			locus_info[5] = paintor_set_size
			locus_info[6] = float(locus_info[4]) / float(locus_info[5])

			cav_bbj_out = results_dir + 'caviar_results_bbj_' + locus_name + '.txt'
			cav_ukb_out = results_dir + 'caviar_results_ukb_' + locus_name + '.txt'
			p = subprocess.Popen(['wc', '-l', cav_bbj_out], stdout=subprocess.PIPE)
			out, err = p.communicate()
			cav_bbj_set_size = int(out.split()[0])
			locus_info[7] = cav_bbj_set_size
			p = subprocess.Popen(['wc', '-l', cav_ukb_out], stdout=subprocess.PIPE)
			out, err = p.communicate()
			cav_ukb_set_size = int(out.split()[0])
			locus_info[8] = cav_ukb_set_size
	all_loci_info.append(locus_info)

all_loci_info.sort(key = lambda x: x[6])
with(open(__location__ + 'setsize_vs_zscores.txt', 'w')) as outfile:
	outfile.write('BBJ_Peak_Zscore\tUKB_Peak_Zscore\tUKB/BBJ_Ratio' +
		'\tSNPs_in_Locus\tMsCAVIAR_Set_Size\tPAINTOR_Set_Size\tM/P_Size_Ratio' +
		'\tCAV_BBJ_Set_Size\tCAV_UKB_Set_Size\n')
	for locus in all_loci_info:
		outfile.write('\t'.join([str(i) for i in locus]) + '\n')
		#print(locus)
#

