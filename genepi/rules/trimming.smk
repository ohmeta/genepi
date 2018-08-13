rule trimming:
    input:
        r1 = os.path.join(config["results"]["raw"]["reads"], "{sample}_1.fq.gz"),
        r2 = os.path.join(config["results"]["raw"]["reads"], "{sample}_2.fq.gz")
    output:
        r1 = os.path.join(config["results"]["trimming"], "{sample}.trimmed.1.fq.gz"),
        r2 = os.path.join(config["results"]["trimming"], "{sample}.trimmed.2.fq.gz"),
        rs = os.path.join(config["results"]["trimming"], "{sample}.trimmed.single.fq.gz"),
        stat_out = os.path.join(config["results"]["trimming"], "{sample}.trimmed.stat_out")
    params:
        prefix = os.path.join(config["results"]["trimming"], "{sample}"),
        qual_system = config["params"]["trimming"]["oas1"]["qual_system"],
        min_length = config["params"]["trimming"]["oas1"]["min_length"],
        seed_oa = config["params"]["trimming"]["oas1"]["seed_oa"],
        fragment_oa = config["params"]["trimming"]["oas1"]["fragment_oa"],
        r1_ = os.path.join(config["results"]["trimming"], "{sample}.clean.1.fq.gz"),
        r2_ = os.path.join(config["results"]["trimming"], "{sample}.clean.2.fq.gz"),
        rs_ = os.path.join(config["results"]["trimming"], "{sample}.clean.single.fq.gz"),
        statout_ = os.path.join(config["results"]["trimming"], "{sample}.clean.stat_out")
    shell:
        '''
        OAs1 {input.r1},{input.r2} {params.prefix} {params.qual_system} {params.min_length} {params.seed_oa} {params.fragment_oa}
        mv {params.r1_} {output.r1}
        mv {params.r2_} {output.r2}
        mv {params.rs_} {output.rs}
        mv {params.statout_} {output.stat_out}
        '''
