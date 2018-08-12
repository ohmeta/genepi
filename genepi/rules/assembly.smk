def assembly_inputs(wildcards):
    if config["params"]["rmhost"]["do"]:
        return expand("{rmhost}/{sample}.rmhost.{read}.fq.gz",
                      rmhost=config["results"]["rmhost"],
                      sample=wildcards.sample,
                      read=["1", "2"])
    else:
        return expand("{trimming}/{sample}.trimmed.{read}.fq.gz",
                      trimming=config["results"]["trimming"],
                      sample=wildcards.sample,
                      read=["1", "2"])


rule assembly:
    input:
        assembly_inputs
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
        os.path.join(config["logs"]["assembly"], "{sample}.megahit.log")
    shell:
        '''
        rm -rf {params.out_dir}
        megahit \
        -1 {input[0]} \
        -2 {input[1]} \
        -t {threads} \
        --min-contig-len {params.min_contig} \
        --out-dir {params.out_dir} \
        --out-prefix {params.out_prefix} 2> {log}
        pigz {params.out_dir}/{params.out_prefix}.contigs.fa
        '''
