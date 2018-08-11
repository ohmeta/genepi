rule trimming:
    input:
        r1 = lambda wildcards: get_sample_id(_samples, wildcards, "fq1"),
        r2 = lambda wildcards: get_sample_id(_samples, wildcards, "fq2")
    output:
        r1 = os.path.join(config["results"]["trimming"], "{sample}.trimmed.1.fq.gz"),
        r2 = os.path.join(config["results"]["trimming"], "{sample}.trimmed.2.fq.gz"),
        single = os.path.join(config["results"]["trimming"], "{sample}.trimmed.single.fq.gz"),
        stat_out = os.path.join(config["results"]["trimming"], "{sample}.trimmed.stat_out")
    params:
        prefix = "{sample}",
        qual_system = config["params"]["trimming"]["oas1"]["qual_system"],
        min_length = config["params"]["trimming"]["oas1"]["min_length"],
        seed_oa = config["params"]["trimming"]["oas1"]["seed_oa"],
        fragment_oa = config["params"]["trimming"]["oas1"]["fragment_oa"]
    shell:
        '''
        OAs1 {input.r1},{input.r2} \
        {params.prefix} \
        {params.qual_system} \
        {params.min_length} \
        {params.seed_oa} \
        {params.fragment_oa}
        '''
