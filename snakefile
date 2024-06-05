# Snakefile
import pandas
import os


configfile: "workflow/.config.yaml"

# Liste aller Dateien im data/illumina-Verzeichnis mit der Endung .fastq.gz
fastq_files = [file for file in os.listdir("data/illumina") if file.endswith(".fastq.gz")]

include: "workflow/rules/fastqc.smk"

# Dynamische Regel, um FastQC für jedes Dateipaar auszuführen
rule fastqc_all:
    input:
        "data/illumina/{sample}_1.fastq.gz",
        "data/illumina/{sample}_2.fastq.gz"
    output:
        fastqc_html = "result/{sample}/quality_control/{sample}_{pair}_fastqc.html",
        fastqc_zip = "result/{sample}/quality_control/{sample}_{pair}_fastqc.zip"
    params:
        directory = "result/{sample}/quality_control"
    conda:
        "../../workflow/env/fastqc.yml"
    shell:
        "mkdir -p {params.directory} && fastqc -o {params.directory} {input}
