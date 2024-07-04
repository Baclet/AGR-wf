# workflow/rules/flye_polish_racon.smk

# Import der benötigten Module
from snakemake.io import expand, glob_wildcards

# Regeln fürs polish der Nanopore Reads mit racon (funktioniert noch nicht)
rule map_for_racon:
    input:
        reads = "result/{sample}/intermediate/nanopore/{sample}.fastq",
        draft = "result/{sample}/intermediate/assembly_flye/medaka/{sample}_flye_medaka.fasta"
    output:
        paf = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon1.paf"
    conda:
        "../../workflow/env/flye_polish_racon.yml"
    threads: 8
    shell:
        "minimap2 -t {threads} -x map-ont {input.draft} {input.reads} > {output.paf}"


rule polish_racon:
    input:
        reads = "result/{sample}/intermediate/nanopore/{sample}.fastq",
        draft = "result/{sample}/intermediate/assembly_flye/medaka/{sample}_flye_medaka.fasta",
        paf = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon1.paf"
    output:
        "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon1.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_flye/polished/racon"
    conda:
        "../../workflow/env/flye_polish_racon.yml"
    threads: 8
    shell:
        """
        mkdir -p {params.outdir}
        racon -t {threads} {input.reads} {input.paf} {input.draft} > {output}
        """
