rule prediction:
    input:
        os.path.join(config["results"]["assembly"],
                     "{sample}.megahit_out/{sample}.contigs.fa.gz")
    output:
        pep = os.path.join(config["results"]["prediction"], "{sample}.pep.faa"),
        cds = os.path.join(config["results"]["prediction"], "{sample}.cds.ffn"),
        gff = os.path.join(config["results"]["prediction"], "{sample}.cds.gff"),
        start = os.path.join(config["results"]["prediction"], "{sample}.score.gff")
    log:
        os.path.join(config["logs"]["prediction"], "{sample}.prodigal.log")
    params:
        format = config["params"]["prediction"]["prodigal"]["format"],
        mode = config["params"]["prediction"]["prodigal"]["mode"]
    shell:
        '''
        prodigal \
        -i {input} \
        -a {output.pep} \
        -d {output.cds} \
        -o {output.gff} \
        -s {output.start} \
        -f {params.format} -p {params.mode} -q \
        2> {log}
        '''
