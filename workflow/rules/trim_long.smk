# workflow/rules/trim_long.smk

# Import der benötigten Module
from snakemake.io import expand, glob_wildcards

# Regel für Nanopore Reads
rule trim_long:
    input:
        "result/{sample}/intermediate/nanopore/{sample}.fastq"
    output:
        "result/{sample}/intermediate/nanopore/{sample}_trimmed.fastq"
    params:
        outdir = "result/{sample}/intermediate/nanopore"
    conda:
        "../../workflow/env/trim.yml"
    shell:
        "porechop -i {input} -o {output}"


rule fastqc_trimmed_long:
    input:
        "result/{sample}/intermediate/nanopore/{sample}_trimmed.fastq"
    output:
        html = "result/{sample}/quality_control/nanopore/{sample}_trimmed_fastqc.html",
        zip = "result/{sample}/quality_control/nanopore/{sample}_trimmed_fastqc.zip"
    params:
        outdir = "result/{sample}/quality_control/nanopore"
    conda:
        "../../workflow/env/trim.yml"
    shell:
        "fastqc -o {params.outdir} --memory 9000 {input}"
