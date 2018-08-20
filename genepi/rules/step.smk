simulation_output = expand(
    [
        "{simulation}/species_metadata.tsv", "{simulation}/{sample}_genome.fa",
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
    "{assembly}/{sample}.megahit_out/{sample}.contigs.fa",
    assembly=config["results"]["assembly"],
    sample=_samples.index)

prediction_output = expand(
    "{prediction}/{sample}.{suffix}",
    prediction=config["results"]["prediction"],
    suffix=["pep.faa", "cds.ffn", "cds.gff", "score.gff"],
    sample=_samples.index)

clustering_output = expand(
    [
        "{clustering}/gene_merged.fa", "{clustering}/geneset.fa",
        "{clustering}/geneset.fa.{suffix}"
    ],
    clustering=config["results"]["clustering"],
    suffix=["amb", "ann", "bwt", "pac", "sa"])

alignment_output = expand(
    "{alignment}/{sample}.bam",
    alignment=config["results"]["alignment"],
    sample=_samples.index)

#profilling_output = expand()

simulation_target = (simulation_output)
trimming_target = (simulation_target + trimming_ouput)
rmhost_target = (trimming_target + rmhost_output)
if config["params"]["rmhost"]["do"]:
    assembly_target = (rmhost_target + assembly_output)
else:
    assembly_target = (trimming_target + assembly_output)
prediction_target = (assembly_target + prediction_output)
clustering_target = (prediction_target + clustering_output)
alignment_target = (clustering_target + alignment_output)
#profilling_target = (alignment_target + profilling_output)

#all_target = (
#    simulation_ouput + trimming_ouput + rmhost_output + assembly_output +
#    prediction_output + dereplication_output + profilling_output)
