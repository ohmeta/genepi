rule gene_merge:
    input:
        expand("{prediction}/{sample}.cds.ffn",
               prediction=config["results"]["prediction"],
               sample=_samples.index)
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
        overlap = config["params"]["dereplication"]["cdhit"]["overlap"],
        wordlen = config["params"]["dereplication"]["cdhit"]["wordlen"],
        global_ = 1 if config["params"]["dereplication"]["cdhit"]["global"] else 0,
        memory = config["params"]["dereplication"]["cdhit"]["memory"],
        clstrlen = config["params"]["dereplication"]["cdhit"]["clstrlen"],
        algorithm = 0 if config["params"]["dereplication"]["cdhit"]["algorithm"] else 1
    threads:
        config["params"]["dereplication"]["cdhit"]["threads"]
    shell:
        '''
        cd-hit-est \
        -i {input} \
        -o {output} \
        -c {params.identity} \
        -n {params.wordlen} \
        -G {params.global_} \
        -aS {params.overlap} \
        -M {params.memory} \
        -d {params.clstrlen}
        -r 1
        -g {params.algorithm}
        -T {threads}
        '''
