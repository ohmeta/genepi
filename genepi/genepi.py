#!/usr/bin/env python

import argparse
import os
import sys

from config import metaconfig, parse_yaml, update_config

__version__ = "0.1.0"

steps = [
    "simulation", "trimming", "rmhost", "assembly", "prediction",
    "dereplication", "profilling"
]


def init(args):
    if args.workdir:
        project = metaconfig(args.workdir)
        print(project.__str__())
        project.create_dirs()
        config = project.get_config()

        if args.samples:
            config["results"]["raw"]["samples"] = args.samples
        else:
            print("please supply a samples list")
            sys.exit(1)

        update_config(
            project.config_file, project.new_config_file, config, remove=False)
    else:
        print("please supply a workdir!")
        sys.exit(1)


def run(args):
    if args.workdir:
        config_file = os.path.join(args.workdir, "config.yaml")
        config = parse_yaml(config_file)
    else:
        print("please supply a workdir!")
        sys.exit(1)

    snakecmd = "snakemake --snakefile %s --configfile %s --until %s" % (
        config["snakefile"], config["configfile"], args.step)
    print(snakecmd)


def main():
    parser = argparse.ArgumentParser(
        prog='genepi',
        usage='genepi [subcommand] [options]',
        description='genepi, a simple pipeline to construct gene catalogue')
    parser.add_argument(
        '-v',
        '--version',
        action='store_true',
        default=False,
        help='print software version and exit')

    parent_parser = argparse.ArgumentParser(add_help=False)
    parent_parser.add_argument(
        '-d', '--workdir', type=str, metavar='<str>', help='project workdir')

    subparsers = parser.add_subparsers(
        title='available subcommands', metavar='')
    parser_init = subparsers.add_parser(
        'init',
        parents=[parent_parser],
        prog='genepi init',
        description='a gene catalogue construction project initialization',
        help='a gene catalogue construction project initialization')
    parser_run = subparsers.add_parser(
        'run',
        parents=[parent_parser],
        prog='genepi run',
        description='run to construct a gene catalogue',
        help='run to construct a gene catalogue')

    parser_init.add_argument('-s', '--samples', help='raw fastq samples list')
    parser_init._optionals.title = 'arguments'
    parser_init.set_defaults(func=init)

    parser_run.add_argument(
        '-u',
        '--step',
        type=str,
        choices=steps,
        default='profilling',
        help='run step')
    parser_run._optionals.title = 'arguments'
    parser_run.set_defaults(func=run)

    args = parser.parse_args()
    try:
        if args.version:
            print("metapi version %s" % __version__)
            sys.exit(0)
        args.func(args)
    except AttributeError as e:
        print(e)
        parser.print_help()


if __name__ == '__main__':
    main()
