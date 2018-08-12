rule genome_download:
    output:
        metadata = os.path.join(config["results"]["simulation"]["genomes"], "species_metadata.tsv")
    params:
        genomes_dir = config["results"]["simulation"]["genomes"],
        taxid = ",".join(config["params"]["simulation"]["taxid"])
    shell:
        '''
        ncbi-genome-download \
        --format fasta,assembly-report \
        --assembly-level complete \
        --taxid {params.taxid} \
        --refseq-category reference \
        --output-folder {params.genomes_dir} \
        --human-readable \
        --retries 3 \
        -m {output.metadata} bacteria
        '''

rule genome_merge:
    input:
        metadata = os.path.join(config["results"]["simulation"]["genomes"], "species_metadata.tsv")
    output:
        expand("{genomes}/{sample}_genome.fa",
               genomes=config["results"]["simulation"]["genomes"],
               sample=_samples.index)
    params:
        genomes_dir = config["results"]["simulation"]["genomes"]
    run:
        '''
        import glob
        import subprocess
        genomes_list = glob.glob(params.genomes_dir + "/refseq/bacteria/*/*genomics.fna.gz")
        cmd_1 = "cat %s > %s" % (" ".join(genomes_list[0:4]), output[0])
        cmd_2 = "cat %s > %s" % (" ".join(genomes_list[1:5]), output[1])
        cmd_3 = "cat %s > %s" % (" ".join(genomes_list[2:6]), output[2])
        subprocess.Popen(cmd_1, shell=True)
        subprocess.Popen(cmd_2, shell=True)
        subprocess.Popen(cmd_3, shell=True)
        '''

rule genome_simulation:
    input:
        os.path.join(config["results"]["simulation"]["genomes"], "{sample}_genome.fa")
    output:
        r1 = os.path.join(config["results"]["raw"]["reads"], "{sample}_1.fq.gz"),
        r2 = os.path.join(config["results"]["raw"]["reads"], "{sample}_2.fq.gz"),
        abundance = os.path.join(config["results"]["raw"]["reads"], "{sample}_abundance.txt")
    params:
        model = config["params"]["simulation"]["model"],
        n_genomes = config["params"]["simulation"]["n_genomes"],
        n_reads = config["params"]["simulation"]["n_reads"],
        prefix = os.path.join(config["results"]["raw"]["reads"], "{sample}")
    threads:
        config["params"]["simulation"]["threads"]
    shell:
        '''
        iss generate --cpus {threads} --genomes {input} --n_genomes {params.n_genomes} --n_reads {params.n_reads} --model {params.model} --output {params.prefix}
        pigz {params.prefix}_R1.fastq
        pigz {params.prefix}_R2.fastq
        mv {params.prefix}_R1.fastq.gz {output.r1}
        mv {params.prefix}_R2.fastq.gz {output.r2}
        '''
