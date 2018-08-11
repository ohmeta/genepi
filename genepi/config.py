#!/usr/bin/env python

import os

from ruamel.yaml import YAML


def parse_yaml(yaml_file):
    yaml = YAML()
    try:
        with open(yaml_file) as f:
            try:
                return yaml.load(f)
            except yaml.YAMLError as exc:
                print(exc)
    except FileNotFoundError as e:
        print(e)


def update_config(yaml_file_old, yaml_file_new, yaml_content, remove=True):
    yaml = YAML()
    yaml.default_flow_style = False
    if remove:
        os.remove(yaml_file_old)
    with open(yaml_file_new, 'w') as f:
        yaml.dump(yaml_content, f)


class metaconfig:
    '''
    config project directory
    '''
    sub_dirs = ["assay", "results", "results/00.simulation"]

    def __init__(self, work_dir):
        self.work_dir = os.path.realpath(work_dir)
        self.config_file = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), "config.yaml")
        self.snake_file = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), "Snakefile")
        self.new_config_file = os.path.join(self.work_dir, "config.yaml")
        self.samples_tsv = os.path.join(self.work_dir,
                                        "results/00.simulation/samples.tsv")

    def __str__(self):
        message = "a gene catalogue construction \
        project has been created at {0}".format(self.work_dir)
        return message

    def create_dirs(self):
        '''
        create project directory
        '''
        if not os.path.exists(self.work_dir):
            os.mkdir(self.work_dir)

        for sub_dir in metaconfig.sub_dirs:
            loc = os.path.join(self.work_dir, sub_dir)
            if not os.path.exists(loc):
                os.mkdir(loc)

    def get_config(self):
        '''
        get default configuration
        '''
        configuration = parse_yaml(self.config_file)
        configuration["snakefile"] = self.snake_file
        configuration["configfile"] = self.new_config_file
        return configuration
