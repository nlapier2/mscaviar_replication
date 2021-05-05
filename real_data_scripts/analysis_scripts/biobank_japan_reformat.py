# A script to reformat Japan Biobank T2D results (doi:10.1038/s41588-018-0332-4)
#    to work with the rest of the MsCAVIAR analysis pipeline.
import argparse, gzip


def parseargs():    # handle user arguments
	parser = argparse.ArgumentParser(description="Given sumstats file, generate" +
		" a formatted file used by subsequent scripts to generate MsCAVIAR input files.")
	parser.add_argument('--infile', required=True, help = 'Summary statistics file.')
	parser.add_argument('--outfile', required=True, help = 'Output file name.')
	args = parser.parse_args()
	return args


def main():
	args = parseargs()
	infile = gzip.open(args.infile, 'r')
	#with(gzip.open(args.infile, 'r')) as infile:
	with(open(args.outfile, 'w')) as outfile:
		header = infile.readline()
		outfile.write('chr pos rsid A0 A1 Zscore\n')
		for line in infile:
			splits = line.strip().split('\t')
			snp_id, chrom, pos, ref, alt, freq, rsq, beta, se = splits[:9]
			snp_id = chrom + ':' + pos
			zscore = str(float(beta) / float(se))
			ordered_fields = [chrom, pos, snp_id, ref, alt, zscore]
			outfile.write(' '.join(ordered_fields) + '\n')
	infile.close()


if __name__ == '__main__':
	main()
#

