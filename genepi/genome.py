#!/usr/bin/env python

import argparse
import gzip
import re

from Bio import SeqIO


def extract_genome(genome, output):
    if genome.endswith(".gz"):
        gh = gzip.open(genome, 'rt')
    else:
        gh = open(genome, 'r')
    with open(output, 'w') as oh:
        for record in SeqIO.parse(gh, 'fasta'):
            if not re.search(r'plasmid', record.description):
                SeqIO.write(record, oh, 'fasta')


def main():
    parser = argparse.ArgumentParser(
        description='extract genome, remove plasmid')
    parser.add_argument(
        '-g',
        '--genome',
        help='genome fasta')
    parser.add_argument(
        '-o',
        '--out',
        help='output genome'
    )
    args = parser.parse_args()
    extract_genome(args.genome, args.out)


if __name__ == "__main__":
    main()
