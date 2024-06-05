# Snakefile
import pandas
from glob import glob


configfile: "workflow/.config.yaml"

include: "workflow/rules/fastqc.smk"

# Hauptregel, um den Workflow auszuführen
rule all:
    input:
	expand("result/{sample}/quality_control/{sample}_{pair}_fastqc.html", sample=[filename.split('/')[-1].split('_')[0] for filename in glob("data/illumina/*.fastq.gz")], pair=["1", "2"]),
        expand("result/{sample}/quality_control/{sample}_{pair}_fastqc.zip", sample=[filename.split('/')[-1].split('_')[0] for filename in glob("data/illumina/*.fastq.gz")], pair=["1", "2"])
