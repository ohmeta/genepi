rule gene_merge:
    input:
        expand("{prediction}/{{sample}}.cds.ffn",
               prediction-config["results"]["prediction"],
               sample=_sample.index())
    output:
        os.path.join(config["results"]["dereplication"], "gene_merged.fa")
    log:
        os.path.join(config["logs"]["dereplication"], "gene_merged.log")
    shell:
        '''
        cat {input} > {output} 2> {log}
        '''

rule dereplication:
    input:
        os.path.join(config["results"]["dereplication"], "gene_merged.fa")
    output:
        os.path.join(config["results"]["dereplication"], "geneset.fa")
    log:
        os.path.join(config["logs"]["dereplication"], "make_geneset.log")
    params:
        identity = config["params"]["dereplication"]["cdhit"]["identity"],
        word_len = config["params"]["dereplication"]["cdhit"]["word_len"],
        global_or_local = 1 if config["params"]["dereplication"]["cdhit"]["global"] else 0,
        align_coverage_shorter_seq = config["params"]["dereplication"]["cdhit"]["align_coverage_shorter_seq"],
        memory_limit = config["params"]["dereplication"]["cdhit"]["memory_limit"],
        len_desc_clstr = config["params"]["dereplication"]["cdhit"]["len_desc_clstr"],
        default_algorithm = 0 if config["params"]["dereplication"]["cdhit"]["default_algorithms"] else 1
    threads:
        config["params"]["dereplication"]["cdhit"]["trheads"]
    shell:
        '''
        cd-hit-est \
        -i {input} \
        -o {output} \
        -c {params.identity} \
        -n {params.word_len} \
        -G {params.global_or_local} \
        -aS {params.align_coverage_shorter_seq} \
        -M {params.memory_limit} \
        -d {params.len_desc_clstr}
        -r 1
        -g {params.default_algorithm}
        -T {threads}
        '''
