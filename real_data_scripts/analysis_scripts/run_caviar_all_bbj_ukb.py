# A helper script that runs CAVIAR on all BBJ/UKB picked loci
import glob, multiprocessing, os, subprocess, sys, traceback


def run_caviar_on_study(ldir, results_dir, study, pruned):
	try:
		#z_files = sorted(glob.glob(ldir + '*.zscores'))
		#ld_files = sorted(glob.glob(ldir + '*.ld'))
		#for i in range(len(z_files)):
			#study_bbj_hdl_sumstats_reformatted.zscores
			#if 'bbj' in z_files[i]:
			#	study = 'bbj'
			#else:
			#	study = 'ukb'

		zfile = ldir + 'study_' + study + '_hdl_sumstats_reformatted.zscores'
		ldfile = ldir + 'study_' + study + '_hdl_sumstats_reformatted.ld'
		result_file = ldir + 'caviar_results_' + study
		subprocess.Popen([caviar_exec, '-l', ldfile, '-z', zfile,
			'-r', '0.95', '-c', '3', '-o', result_file]).wait()
		if pruned:
			final_fname = results_dir + 'caviar_results_' + study + '_' + ldir.split(
				pipeline_outdir)[1].split('/')[0] + '.txt'
		else:
			final_fname = results_dir + 'unpruned_caviar_results_' + study + '_' + ldir.split(
				pipeline_outdir)[1].split('/')[0] + '.txt'
		#subprocess.Popen([caviar_exec, '-l', ld_files[i], '-z', z_files[i],
		#	'-r', '0.95', '-c', '3', '-o', result_file]).wait()
		#final_fname = results_dir + 'caviar_results_' + study + '_' + ldir.split(
		#	pipeline_outdir)[1].split('/pruned/')[0] + '.txt'
		subprocess.Popen(['cp', result_file + '_set', final_fname]).wait()
	except:
		print('Error in process for ' + str(ldir))
		err = sys.exc_info()
		tb = traceback.format_exception(err[0], err[1], err[2])
		print(''.join(tb) + '\n')
		sys.stdout.flush()


locus_number, study = int(sys.argv[1]), sys.argv[2]
if len(sys.argv) > 3 and sys.argv[3] == 'pruned':
	pruned = True
else:
	pruned = False


__location__ = os.path.realpath(os.path.join(os.getcwd(), os.path.dirname(__file__))) + '/'
caviar_exec = __location__ + 'CAVIAR'
pipeline_outdir = __location__ + '../loci_win500kb_minpeakZ5pt2_minsnpZ1pt96_min10snp/' # '../loci_minpeakZ5pt2_minsnpZ3pt9_min10snp/'
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
	pool.apply_async(run_caviar_on_study, (ldir, results_dir,))
pool.close()
pool.join()
'''

ldir = locus_dirs[locus_number - 1]  # change to 0-indexed
run_caviar_on_study(ldir, results_dir, study, pruned)
#

