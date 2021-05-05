"""
This script takes plink LD lists and simulates lambda for multiple populations. Requires 2 populations, can take up to 4.
"""
import argparse
from contextlib import ExitStack
import numpy as np
import scipy.stats as stats
import os
import math
import glob

class Main():

  def __init__(self):
    self.bim = ""
    self.loci = []
    self.out = []
    self.causal = 1
    self.sims = 10
    # self.tau_sqr = 0.5
    self.num_snps = 0 # num of snps in the input LD matrix
    self.upper = 5.2
    self.lower = 0
    self.sample_size = 9000

    self.define_parser()  
    for i in range(self.sims):
        self.simulate(i)

  #define_parser is argparser
  def define_parser(self):
    parser = argparse.ArgumentParser(description = 'This script generates summary statistics using plink LD lists. Assumes LD matrices are whitespace delimited.')
    # should be now matrices not pairwise lists
    parser.add_argument('-b1', '--bim', dest = 'bim', required = True, help = 'Location of subsetted .bim file for any population')
    parser.add_argument('-o','--out_dir', dest = 'out', required = False, default = './', help = 'Directory for output files. Default: ./')
    parser.add_argument('-c', '--causal', dest = 'causal', required = False, default = 1, help = 'Number of causal SNP. Default: 1')
    parser.add_argument('-s', '--sims', dest = 'sims', required = False, default = 10, help = 'Number of simulations for each configuration. Default: 100')
    parser.add_argument('-u', '--upperbound', dest = 'upperbound', required = False, default = 5.2, help = 'threshold for significant lambda: Default: 5.2')
    parser.add_argument('-l', '--lowerbound', dest = 'lowerbound', required = False, default = 3, help = 'threshold for marginally significant lambda: Default: 3')
    parser.add_argument('-r', dest = 'r', required=True, help = 'Directory with LD matrices.')
    args = parser.parse_args()
    self.read_parser(args)

  #make args part of class
  def read_parser(self, args):
    splits = args.out.split('/')
    if len(splits) > 1:  # not in current dir
      output = '/'.join(splits[:]) + '/'
    else:
      output = splits[0]

    # read in LD matrices
    self.bim = args.bim
    
    self.createFolder(output)
    self.loci = self.read_bim(self.bim)

    self.r = args.r
    self.ldmats = self.read_ld(self.r)

    # causal.snplist, 1 for 1st Euro study, 2 for 2nd Euro study, 3 for Asn study
    # same causal snps but different effect sizes
    self.out.append(output + 'EURO1')
    self.out.append(output + 'EURO2')
    self.out.append(output + 'ASN')
    self.out.append(output + 'EUROs')

    self.num_snps = len(self.loci)

    self.causal = int(args.causal)
    self.sims = int(args.sims)
    self.upper = float(args.upperbound)
    self.lower = float(args.lowerbound)

  def read_bim(self, read_fn):
    f = open(read_fn,'r')
    SNPs = []
    for line in f:
        line = line.strip()
        array = line.split()
        SNPs.append(array[1])
    return SNPs

  def createFolder(self, directory):
    """
    this function can ONLY create if there is no folder already existing, if exist, will NOT overwrite
    """
    try:
        if not os.path.exists(directory):
            os.makedirs(directory)
    except OSError:
        print('Error: creating directory. ' + directory)

  def read_ld(self, ld_dir):
    ldmats = []
    ldfiles = glob.glob(ld_dir + '*.ld')
    for ld_fname in ldfiles:
      with(open(ld_fname, 'r')) as infile:
        this_ld = []
        for line in infile:
          ld_row = line.strip().split()
          ld_row = [float(i) for i in ld_row]
          this_ld.append(ld_row)
        ldmats.append(this_ld)
    return ldmats

  def is_valid_draw(self, causals):
    if len(causals) == 1:
      return True
    causal_indices = [self.loci.index(i) for i in causals]
    for i in range(len(self.ldmats)):
      r = self.ldmats[i][causal_indices[0]][causal_indices[1]]
      if r < 0.0: # or r > 0.5:
        return False
    if len(causals) == 2:
      return True
    for i in range(len(self.ldmats)):
      r = self.ldmats[i][causal_indices[0]][causal_indices[2]]
      if r < 0.0: # or r > 0.5:
        return False
    for i in range(len(self.ldmats)):
      r = self.ldmats[i][causal_indices[1]][causal_indices[2]]
      if r < 0.0: # or r > 0.5:
        return False
    return True

  def draw_causal(self):
    causals = []
    ten_quantile = int(self.num_snps * 0.1)
    ninety_quantile = int(self.num_snps * 0.9)
    vals = sorted(np.random.choice(self.loci[ten_quantile:ninety_quantile], size = self.causal, replace = False))
    for i in vals:
      causals.append(i)

    while not self.is_valid_draw(causals):
      causals = []
      vals = sorted(np.random.choice(self.loci[ten_quantile:ninety_quantile], size = self.causal, replace = False))
      for i in vals:
        causals.append(i)

    return causals

  def simulate(self, index):
    all_lambda_1 = []
    all_lambda_2 = []
    causals = self.draw_causal()
    
    while len(all_lambda_1) < self.causal:
      #tmp_lambda_1 = abs(np.random.normal(loc = 0, scale = math.sqrt(5.2), size = 1))
      #tmp_lambda_2 = abs(np.random.normal(loc = 0, scale = math.sqrt(5.2), size = 1))
      tmp_lambda_1 = abs(np.random.normal(loc = 5.2, scale = math.sqrt(1.0), size = 1))
      tmp_lambda_2 = abs(np.random.normal(loc = 5.2, scale = math.sqrt(1.0), size = 1))
      
      if tmp_lambda_1[0] >= self.lower and tmp_lambda_2[0] >= self.lower:
        if tmp_lambda_1[0] >= self.upper or tmp_lambda_2[0] >= self.upper:
          all_lambda_1.append(tmp_lambda_1[0]/math.sqrt(self.sample_size))
          all_lambda_2.append(tmp_lambda_2[0]/math.sqrt(self.sample_size))

    for i in range(len(self.out)):
      f_name = self.out[i] + '_' + str(index+1) + '.causal.snplist'
      f = open(f_name,'w')
      for k in range(self.causal):
        if i==0:
          f.write(str(causals[k]) + "\t" + str(all_lambda_1[k]))
        elif i==1 or i==2:
          f.write(str(causals[k]) + "\t" + str(all_lambda_2[k]))
          # f.write(str(causals[k]) + "\t" + str(all_lambda_1[k]))
        elif i==3: # EUROs, double the sample size (18000) so divide by sqrt(2)
          f.write(str(causals[k]) + "\t" + str(all_lambda_2[k]/math.sqrt(2)))
          # f.write(str(causals[k]) + "\t" + str(all_lambda_1[k]/math.sqrt(2)))
        f.write("\n")
      f.close()

if __name__ == '__main__':
  Main()
