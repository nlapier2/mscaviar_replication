import argparse
import glob
import math
import numpy as np
import pandas as pd


def parseargs():    # handle user arguments
    parser = argparse.ArgumentParser(description='Assess recall and causal set sizes produced by fine mapping methods.')
    parser.add_argument('--num_causal', default='*', help='Number of causal SNPs.')
    parser.add_argument('--heritability', default='*', help='Heritability levels to assess.')
    parser.add_argument('--loci', default='*', help='Loci to look at (high, medium, and/or low).')
    parsed_args = parser.parse_args()
    return parsed_args


def find_quartile(set_sizes, quartile):
    quartile_index = (len(set_sizes) - 1) * quartile
    if quartile_index.is_integer():
        return set_sizes[int(quartile_index)]
    else:
        floor_val = set_sizes[int(quartile_index)]
        ceil_val = set_sizes[math.ceil(quartile_index)]
        return (floor_val + ceil_val) / 2.0


# Given all the files with causal set sizes, compute the interquartile range (iqr)
def get_config_iqr(input_fnames):
    config_sizes = []
    iqr = []
    for fname in input_fnames:
        with(open(fname, 'r')) as infile:
            for line in infile:
                config_sizes.append(float(line.strip()))
    config_sizes.sort()
    iqr.append(config_sizes[0])  # min
    iqr.append(find_quartile(config_sizes, 0.25))
    iqr.append(find_quartile(config_sizes, 0.5))
    iqr.append(find_quartile(config_sizes, 0.75))
    iqr.append(config_sizes[-1])  # max
    iqr.append(np.mean(config_sizes))  # mean
    return iqr


# Give all the files with the recall rates, compute the average recall rate
def get_recall_mean(input_fnames):
    recalls = []
    for fname in input_fnames:
        with(open(fname, 'r')) as infile:
            for line in infile:
                recalls.append(float(line.strip()))
    return np.mean(recalls)


if __name__ == '__main__':
    args = parseargs()
    dir_string = 'Simulation/multi_test/causal_' + args.num_causal + '_ld_' \
                 + args.loci + '_h2_' + args.heritability + '/out/0/'
    methods_pt1 = ['caviar', 'caviar', 'caviar', 'caviar', 'mscaviar', 'mscaviar', 'mscaviar', 'mscaviar', 'paintor',
                   'susie_ASN', 'susie_EURO1']
    methods_pt2 = ['_ASN', '_EURO1', '_EURO2', '_EUROs', '', '_cutoff', '_EUROs', '_EUROs_cutoff', '', '', '']
    # Simulation/multi_test/causal_2_ld_medium_h2_0.0025/out/0/R_mscaviar_0_EUROs_cutoff_config_size.txt

    # Iterate over methods, computing the interquartile range (iqr) of their causal set sizes and their average recall
    config_iqrs, recall_means = {}, {}
    for i in range(len(methods_pt1)):
        m1, m2 = methods_pt1[i], methods_pt2[i]
        method_name = m1 + m2
        # if m2 != '':
        #     method_name = m1 + '_' + m2
        # else:
        #     method_name = m1
        config_fnames = glob.glob(dir_string + 'R_' + m1 + '_0' + m2 + '_config_size.txt')
        recall_fnames = glob.glob(dir_string + 'R_' + m1 + '_0' + m2 + '_recall_rate.txt')
        # print(dir_string + 'R_' + m1 + '_0_' + m2 + '_config_size.txt')
        # print(config_fnames)
        config_iqrs[method_name] = get_config_iqr(config_fnames)
        recall_means[method_name] = get_recall_mean(recall_fnames)

    config_df = pd.DataFrame.from_dict(config_iqrs)
    config_df.index = ['min', '1st qrt', 'median', '3rd qrt', 'max', 'mean']
    # recall_df = pd.DataFrame.from_dict(recall_means)
    print('Configuration sizes:\n')
    print(config_df)
    print('\n\nRecall rates:\n')
    # print(recall_df)
    print(recall_means)
    print()
