# workflow/rules/fastqc.smk

# Import der benötigten Module
from snakemake.io import expand, glob_wildcards

# Regel für Illumina Reads
rule fastqc_short:
    input:
        "data/illumina/{sample}_{pair}.fastq.gz"
    output:
        html = "result/{sample}/quality_control/illumina/{sample}_{pair}_fastqc.html",
        zip = "result/{sample}/quality_control/illumina/{sample}_{pair}_fastqc.zip"
    params:
        outdir = "result/{sample}/quality_control/illumina"
    conda:
        "../../workflow/env/fastqc.yml"
    shell:
        "fastqc -o {params.outdir} {input}"

# Regel für Nanopore Reads
rule fastqc_long:
    input:
        "result/{sample}/intermediate/nanopore/{sample}.fastq"
    output:
        html = "result/{sample}/quality_control/nanopore/{sample}_fastqc.html",
        zip = "result/{sample}/quality_control/nanopore/{sample}_fastqc.zip"
    params:
        outdir = "result/{sample}/quality_control/nanopore"
    conda:
        "../../workflow/env/fastqc.yml"
    shell:
        "fastqc -o {params.outdir} --memory 9000 {input}"
