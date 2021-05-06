import sys
#import deeptools
import numpy as np 
from itertools import chain
import argparse
import os
import csv

# output file header:
# [0] chr
# [1] start pos
# [2] end pos
# [3] strain present in
# [4] CTCF start pos
# [5] CTCF end pos

def read_ID(ID_fn):
    """
    reads in each line in the id_to_ethnicity file
    :param read_fn the name of file to be read
    """
    print("Reading id_to_ethnicity file...")
    with open(ID_fn, newline='') as f:
        readCSV = csv.reader(f, delimiter=',')
        id_to_ethnicity = []
        for array in readCSV:
            if len(array) != 2: # avoid empty rows
                break
            id_to_ethnicity.append([array[0], array[1]]) #[0]: patient_ID, [1]: Ethnicity

    return id_to_ethnicity

def read_filter4(filter4_fn):
    print("Reding filter4 file...")
    f = open(filter4_fn,'r')
    unrelated_British = set()
    array = []
    for line in f:
        line = line.strip()
        array = line.split()
        unrelated_British.add(array[0])
    
    return unrelated_British

def subset_ID_by_ethnicity(id_to_ethnicity, unrelated_British, sample_size = 9000):
    ASN_sample_1 = []
    EUR_sample_2 = []
    EUR_sample_3 = []

    ASN_full = False
    EUR_full = False

    for i in range(len(id_to_ethnicity)):
        if id_to_ethnicity[i][1] == 'British':
        # if id_to_ethnicity[i][1] == 'British' and id_to_ethnicity[i][0] in unrelated_British:
            if len(EUR_sample_2) < 9000:
                EUR_sample_2.append(id_to_ethnicity[i])
            elif len(EUR_sample_3) < 9000:
                EUR_sample_3.append(id_to_ethnicity[i])
            else:
                EUR_full = True
        elif id_to_ethnicity[i][1] == 'Any other Asian background' or id_to_ethnicity[i][1] == 'Chinese' or id_to_ethnicity[i][1] == 'Indian':
            if len(ASN_sample_1) < 9000:
                ASN_sample_1.append(id_to_ethnicity[i])
            else:
                ASN_full = True
        if EUR_full and ASN_full:
            break

    return ASN_sample_1, EUR_sample_2, EUR_sample_3

def output_subsamples(ASN_sample_1, EUR_sample_2, EUR_sample_3, ASN_out_1, EUR_out_2, EUR_out_3, ALL_out_4):
    out = open(ASN_out_1,'w')
    # no header for fam file
    for i in range(len(ASN_sample_1)):
        out.write(str(ASN_sample_1[i][0]) + '\t' + str(ASN_sample_1[i][0]) + '\n')
    out.close()

    out = open(EUR_out_2,'w')
    # no header for fam file
    for i in range(len(EUR_sample_2)):
        out.write(str(EUR_sample_2[i][0]) + '\t' + str(EUR_sample_2[i][0]) + '\n')
    out.close()

    out = open(EUR_out_3,'w')
    # no header for fam file
    for i in range(len(EUR_sample_3)):
        out.write(str(EUR_sample_3[i][0]) + '\t' + str(EUR_sample_3[i][0]) + '\n')
    out.close()

    ALL_sample_4 = []
    ALL_sample_4.extend(ASN_sample_1)
    ALL_sample_4.extend(EUR_sample_2)
    ALL_sample_4.extend(EUR_sample_3)
    out = open(ALL_out_4,'w')
    # no header for fam file
    for i in range(len(ALL_sample_4)):
        out.write(str(ALL_sample_4[i][0]) + '\t' + str(ALL_sample_4[i][0]) + '\n')
    out.close()

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Subsetting UK Biobank data into 1 Asian + 2 European samples')
    parser.add_argument('-d', '--id', required=True, dest='id_to_ethnicity_file',
                        help='id_to_ethnicity_file from UK Biobank')
    parser.add_argument('-s', '--size', required=False, dest='sample_size',
                        help='sample size of each subsample')
    parser.add_argument('-o', '--out_ASN', required=True, dest='ASN_out_1',
                        help='output path for Asian sample')
    parser.add_argument('-u', '--out_EUR1', required=True, dest='EUR_out_2',
                        help='output path for European sample 1')
    parser.add_argument('-t', '--out_EUR2', required=True, dest='EUR_out_3',
                        help='output path for European sample 2')
    parser.add_argument('-v', '--out_ALL', required=True, dest='ALL_out_4',
                        help='output path for All sample')
    parser.add_argument('-f', '--filter4', required=True, dest='filter_file',
                        help='filter4 file for unrelated British people')

    
    args = parser.parse_args()
    if args.sample_size:
        sample_size = args.sample_size

    ID_fn = args.id_to_ethnicity_file
    filter4_fn = args.filter_file

    ASN_out_1 = args.ASN_out_1
    EUR_out_2 = args.EUR_out_2
    EUR_out_3 = args.EUR_out_3
    ALL_out_4 = args.ALL_out_4

    id_to_ethnicity = read_ID(ID_fn)
    unrelated_British = read_filter4(filter4_fn)
    ASN_sample_1, EUR_sample_2, EUR_sample_3 = subset_ID_by_ethnicity(id_to_ethnicity, unrelated_British)
    output_subsamples(ASN_sample_1, EUR_sample_2, EUR_sample_3, ASN_out_1, EUR_out_2, EUR_out_3, ALL_out_4)


