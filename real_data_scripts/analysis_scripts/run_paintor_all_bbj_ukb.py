# A helper script that runs PAINTOR on all BBJ/UKB picked loci
import glob, multiprocessing, os, subprocess, sys, traceback


def make_paintor_zfile_from_all_zfiles(locus_dir, z_files):
	snp_to_info, num_zscores, num_snps = {}, 1, 0
	with(open(z_files[0].replace('.zscores', '.processed'), 'r')) as infile:
		header = infile.readline()
		for line in infile:
			num_snps += 1
			splits = line.strip().split(' ')
			rsid = splits[2]
			snp_to_info[rsid] = splits
	for i in range(1, len(z_files)):
		with(open(z_files[i].replace('.zscores', '.processed'), 'r')) as infile:
			header = infile.readline()
			for line in infile:
				splits = line.strip().split(' ')
				rsid, zscore = splits[2], splits[-1]
				snp_to_info[rsid].append(zscore)
				num_zscores += 1
	paintor_outname = locus_dir + 'paintor'
	with(open(paintor_outname, 'w')) as outfile:
		outfile.write('chr pos rsid A0 A1')
		for i in range(len(z_files)):
			outfile.write(' z' + str(i))
		outfile.write('\n')
		for snp in snp_to_info:
			outfile.write(' '.join(snp_to_info[snp]) + '\n')
	return paintor_outname, num_snps


def run_paintor_on_locus(ldir):
	try:
		# first need to prepare input files for PAINTOR
		z_files = sorted(glob.glob(ldir + '*.zscores'))
		ld_files = sorted(glob.glob(ldir + '*.ld'))
		paintor_outname, num_snps = make_paintor_zfile_from_all_zfiles(ldir, z_files)
		for i in range(len(ld_files)):
			subprocess.Popen(['cp', ld_files[i], paintor_outname + '.ld' + str(i)]).wait()
		with(open(ldir + 'input.files', 'w')) as outfile:
			outfile.write(paintor_outname.split('/')[-1])
		with(open(paintor_outname + '.annotations', 'w')) as outfile:
			outfile.write('empty_annotation\n')
			for i in range(num_snps):
				outfile.write('0\n')
		# now run PAINTOR
		result_file = ldir + 'paintor_results'
		zhead, ldhead = '', ''
		for i in range(len(z_files)):
			zhead += 'z' + str(i) + ','
			ldhead += 'ld' + str(i) + ','
		zhead, ldhead = zhead[:-1], ldhead[:-1]  # strip off trailing comma
		subprocess.Popen([paintor_exec, '-input', ldir + 'input.files',
		 	'-in', ldir, '-out', ldir, '-Zhead', zhead, '-LDname', ldhead,
			'-annotations', 'empty_annotation', '-max_causal', '3']).wait()
	except:
		print('Error in process for ' + str(ldir))
		err = sys.exc_info()
		tb = traceback.format_exception(err[0], err[1], err[2])
		print(''.join(tb) + '\n')
		sys.stdout.flush()


locus_number = int(sys.argv[1])
if len(sys.argv) > 2 and sys.argv[2] == 'pruned':
	pruned = True
else:
	pruned = False

__location__ = os.path.realpath(os.path.join(os.getcwd(), os.path.dirname(__file__))) + '/'
paintor_exec = __location__ + 'PAINTOR'
pipeline_outdir = __location__ + '../loci_win500kb_minpeakZ5pt2_minsnpZ1pt96_min10snp/'  # '../loci_minpeakZ5pt2_minsnpZ3pt9_min10snp/'
locus_dirs = next(os.walk(pipeline_outdir))[1]
if pruned:
	locus_dirs = [pipeline_outdir + i + '/pruned/' for i in locus_dirs if i != 'results']
else:
	locus_dirs = [pipeline_outdir + i + '/' for i in locus_dirs if i != 'results']

'''
num_processes = 12
pool = multiprocessing.Pool(processes = num_processes)
for ldir in locus_dirs:  # picked_locus_dirs:
	pool.apply_async(run_paintor_on_locus, (ldir,))
pool.close()
pool.join()
'''

ldir = locus_dirs[locus_number - 1]  # change to 0-indexed
run_paintor_on_locus(ldir)
#

