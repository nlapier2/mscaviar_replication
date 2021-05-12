import glob
import pandas as pd

all_fnames = glob.glob('final_paper_results/*')
locus_results = {}
for fname in all_fnames:
    line_count = 0
    with(open(fname, 'r')) as infile:
        for line in infile:
            line_count += 1

    if 'caviar' in fname and 'bbj' in fname:
        prefix = 'unpruned_caviar_results_bbj_'
        method = 'CAVIAR-Asian'
    elif 'caviar' in fname and 'ukb' in fname:
        prefix = 'unpruned_caviar_results_ukb_'
        method = 'CAVIAR-Euro'
    elif 'paintor' in fname:
        prefix = 'unpruned_paintor_results_'
        method = 'PAINTOR'
    else:
        prefix = 'unpruned_runtime_mscaviar_results_'
        method = 'MsCAVIAR'

    locus_name = fname.split(prefix)[1].split('.txt')[0]
    if locus_name not in locus_results:
        locus_results[locus_name] = {}
    locus_results[locus_name][method] = line_count

df = pd.DataFrame(locus_results).T
df.to_csv('locus_set_sizes.txt', sep='\t')
