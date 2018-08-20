# genepi
help you to contruct a mini gene catalogue

# install
```bash
git clone https://github.com/ohmeta/genepi
```
# rules
see genepi/Snakefile
```python
include: "rules/step.smk"
include: "rules/simulation.smk"
include: "rules/trimming.smk"
include: "rules/rmhost.smk"
include: "rules/assembly.smk"
include: "rules/prediction.smk"
include: "rules/clustering.smk"
include: "rules/alignment.smk"
include: "rules/profilling.smk"
```

# run
```
python genepi/genepi.py --help
snakemke --snakefile genepi/Snakefile --configflie genepi/config.yaml --list
```
