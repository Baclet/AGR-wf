# Snakefile
import os

configfile: "workflow/.config.yaml"

# Liste aller Dateien im data/illumina-Verzeichnis mit der Endung .fastq.gz
fastq_files = [file.split('_1.fastq.gz')[0] for file in os.listdir("data/illumina") if file.endswith("_1.fastq.gz")]

# Regel für FastQC
include: "workflow/rules/fastqc.smk"

# Dynamische Regel, um FastQC für jedes Dateipaar auszuführen
rule fastqc_all:
    input:
        expand("data/illumina/{sample}_{pair}.fastq.gz", sample=fastq_files, pair=["1", "2"])
    output:
        fastqc_html = "result/{sample}/quality_control/{sample}_{pair}_fastqc.html",
        fastqc_zip = "result/{sample}/quality_control/{sample}_{pair}_fastqc.zip"
    params:
        directory = "result/{sample}/quality_control"
    conda:
        "../../workflow/env/fastqc.yml"
    shell:
        "mkdir -p {params.directory} && fastqc -o {params.directory} {input}"
