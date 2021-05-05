# A helper script that runs MsCAVIAR on all BBJ/UKB picked loci
import glob, multiprocessing, os, subprocess, sys, traceback


def run_mscaviar_on_locus(ldir, results_dir, pruned):
	try:
		# first need to prepare input files for MsCAVIAR with paths to LD/Zscore files
		zfiles_list_file = ldir + 'zfiles.txt'
		ldfiles_list_file = ldir + 'ldfiles.txt'
		# now run MsCAVIAR
		result_file = ldir + 'runtime_mscaviar_results'
		subprocess.Popen([mscaviar_exec, '-l', ldfiles_list_file, '-z',
			zfiles_list_file, '-r', '0.95', '-t', '0.52', '-c', '3', #'2',
			'-a', '0.00', '-n', '70657,361194', '-o', result_file]).wait()
			#'-n', '191764,361194', '-o', result_file]).wait()
		if pruned:
			final_fname = results_dir + 'runtime_mscaviar_results_' + ldir.split(
				pipeline_outdir)[1].split('/pruned/')[0] + '.txt'
		else:
			final_fname = results_dir + 'unpruned_runtime_mscaviar_results_' + ldir.split(
				pipeline_outdir)[1].split('/')[0] + '.txt'
		subprocess.Popen(['cp', result_file + '_set.txt', final_fname]).wait()
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
mscaviar_exec = __location__ + 'MsCAVIAR'
pipeline_outdir = __location__ + '../loci_win500kb_minpeakZ5pt2_minsnpZ1pt96_min10snp/'   # '../loci_minpeakZ5pt2_minsnpZ3pt9_min10snp/'
results_dir = pipeline_outdir + 'results/'
locus_dirs = next(os.walk(pipeline_outdir))[1]
if pruned:
	locus_dirs = [pipeline_outdir + i + '/pruned/' for i in locus_dirs if i != 'results']
else:
	locus_dirs = [pipeline_outdir + i + '/' for i in locus_dirs if i != 'results']

'''
num_processes = 12
pool = multiprocessing.Pool(processes = num_processes)
for ldir in locus_dirs:  # picked_locus_dirs:
	pool.apply_async(run_mscaviar_on_locus, (ldir, results_dir,))
pool.close()
pool.join()
'''

ldir = locus_dirs[locus_number - 1]  # change to 0-indexed
print('Locus num: ' + str(locus_number) + ' ; locus dir: ' + ldir)
run_mscaviar_on_locus(ldir, results_dir, pruned)
#

