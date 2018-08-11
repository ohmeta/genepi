rule assembly:
    input:
        r1 = os.path.join(config["results"]["rmhost"], "{sample}.rmhost.1.fq.gz"),
        r2 = os.path.join(config["results"]["rmhost"], "{sample}.rmhost.2.fq.gz")
    output:
        contigs = os.path.join(config["results"]["assembly"],
                               "{sample}.megahit_out/{sample}.contigs.fa.gz"),
        intermediate = temp(directory(os.path.join(config["results"]["assembly"],
                                                   "{sample}.megahit_out/intermediate_contigs")))
    params:
        min_contig = config["params"]["assembly"]["megahit"]["min_contig"],
        out_dir = os.path.join(config["results"]["assembly"], "{sample}.megahit_out"),
        out_prefix = "{sample}"
    threads:
        config["params"]["assembly"]["megahit"]["threads"]
    log:
        os.path.join(config["logs"]["assembly"]["megahit"], "{sample}.megahit.log")
    shell:
        '''
        rm -rf {params.out_dir}
        megahit \
        -1 {input.r1} \
        -2 {input.r2} \
        -t {threads} \
        --min-contig-len {params.min_contig} \
        --out-dir {params.out_dir} \
        --out-prefix {params.out_prefix} 2> {log}
        pigz {params.out_dir}/{params.out_prefix}.contigs.fa
        '''
