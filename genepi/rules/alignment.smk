rule alignment:
    input:
        reads = expand("{trimming}/{{sample}}.trimmed.{read}.fq.gz",
                       trimming=config["results"]["trimming"],
                       read=["1", "2"]),
        index = expand("{prefix}.{suffix}",
                       prefix=os.path.join(config["results"]["clustering"], "geneset.fa"),
                       suffix=["amb", "ann", "bwt", "pac", "sa"])
    output:
        os.path.join(config["results"]["alignment"], "{sample}.bam")
    log:
        os.path.join(config["logs"]["alignment"], "{sample}.align.geneset.log")
    params:
        index = os.path.join(config["results"]["clustering"], "geneset.fa")
    threads:
        config["params"]["alignment"]["bwa"]["threads"]
    shell:
        '''
        bwa mem -t {threads} -M {params.index} {input.reads} | samtools view -Sb - > {output}
        '''
