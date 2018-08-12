simulation_output = expand(
    [
        "{simulation}/species_metadata.tsv",
        "{simulation}/{sample}_genome.fa",
        "{reads}/{sample}_{read}.fq.gz"
    ],
    simulation=config["results"]["simulation"],
    reads=config["results"]["raw"]["reads"],
    read=["1", "2"],
    sample=_samples.index)

trimming_ouput = expand(
    [
        "{trimming}/{sample}.trimmed.{read}.fq.gz",
        "{trimming}/{sample}.trimmed.stat_out"
    ],
    trimming=config["results"]["trimming"],
    read=["1", "2", "single"],
    sample=_samples.index)

rmhost_output = expand(
    "{rmhost}/{sample}.{read}.fq.gz",
    rmhost=config["results"]["rmhost"],
    read=["1", "2"],
    sample=_samples.index)

assembly_output = expand(
    "{assembly}/{sample}.megahit_out/{sample}.contigs.fa.gz",
    assembly=config["results"]["assembly"],
    sample=_samples.index)

prediction_output = expand(
    "{prediction}/{sample}.{suffix}",
    prediction=config["results"]["prediction"],
    suffix=["pep.faa", "cds.ffn", "cds.gff", "score.gff"],
    sample=_samples.index)

dereplication_output = expand(
    [
        "{dereplication}/gene_merged.fa",
        "{dereplication}/geneset.fa"
    ],
    dereplication=config["results"]["dereplication"])

#profilling_output = expand()

simulation_target = (simulation_output)
trimming_target = (simulation_target + trimming_ouput)
rmhost_target = (trimming_target + rmhost_output)
if config["params"]["rmhost"]["do"]:
    assembly_target = (rmhost_target + assembly_output)
else:
    assembly_target = (trimming_target + assembly_output)
prediction_target = (assembly_target + prediction_output)
dereplication_target = (prediction_target + dereplication_output)
#profilling_target = (dereplication_target + profilling_output)

#all_target = (
#    simulation_ouput + trimming_ouput + rmhost_output + assembly_output +
#    prediction_output + dereplication_output + profilling_output)
