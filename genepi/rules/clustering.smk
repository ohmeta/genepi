rule gene_merge:
    input:
        expand("{prediction}/{sample}.cds.ffn",
               prediction=config["results"]["prediction"],
               sample=_samples.index)
    output:
        os.path.join(config["results"]["clustering"], "gene_merged.fa")
    log:
        os.path.join(config["logs"]["clustering"], "gene_merged.log")
    shell:
        '''
        cat {input} > {output} 2> {log}
        '''

rule clustering:
    input:
        os.path.join(config["results"]["clustering"], "gene_merged.fa")
    output:
        os.path.join(config["results"]["clustering"], "geneset.fa")
    log:
        os.path.join(config["logs"]["clustering"], "cdhit.geneset.log")
    params:
        identity = config["params"]["clustering"]["cdhit"]["identity"],
        overlap = config["params"]["clustering"]["cdhit"]["overlap"],
        wordlen = config["params"]["clustering"]["cdhit"]["wordlen"],
        global_ = 1 if config["params"]["clustering"]["cdhit"]["global"] else 0,
        memory = config["params"]["clustering"]["cdhit"]["memory"],
        clstrlen = config["params"]["clustering"]["cdhit"]["clstrlen"],
        default_algorithm = 0 if config["params"]["clustering"]["cdhit"]["default_algorithm"] else 1,
        both_alignment = 1 if config["params"]["clustering"]["cdhit"]["both_alignment"] else 0
    threads:
        config["params"]["clustering"]["cdhit"]["threads"]
    shell:
        '''
        cd-hit-est -i {input} -o {output} \
        -c {params.identity} \
        -n {params.wordlen} \
        -G {params.global_} \
        -aS {params.overlap} \
        -M {params.memory} \
        -d {params.clstrlen} \
        -g {params.default_algorithm} \
        -r {params.both_alignment} \
        -T {threads} 2> {log}
        '''

rule geneset_index:
    input:
        os.path.join(config["results"]["clustering"], "geneset.fa")
    output:
        expand("{prefix}.{suffix}",
               prefix=os.path.join(config["results"]["clustering"], "geneset.fa"),
               suffix=["amb", "ann", "bwt", "pac", "sa"])
    log:
        os.path.join(config["results"]["clustering"], "geneset.index.log")
    shell:
        "bwa index {input} 2> {log}"

