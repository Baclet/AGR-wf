# workflow/rules/fastqc.smk

# import sample names
from snakemake.io import expand, glob_wildcards

# rule to do the fastqc for the illumina reads
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
        "fastqc -o {params.outdir} -t 4 --memory 6000 {input}"

# rule to do the fastqc for the nanopore reads
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
        "fastqc -o {params.outdir} -t 4 --memory 6000 {input}"
