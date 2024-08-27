# workflow/rules/flye_polish_racon.smk

# import sample names
from snakemake.io import expand, glob_wildcards

# rule to polish the nanopore assembly 5x with racon
rule map_for_raconI:
    input:
        reads = "result/{sample}/intermediate/nanopore/{sample}.fastq",
        draft = "result/{sample}/intermediate/assembly_flye/medaka/{sample}_flye_medaka.fasta"
    output:
        paf = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon1.paf"
    conda:
        "../../workflow/env/flye_polish_racon.yml"
    threads: 20
    shell:
        "minimap2 -t {threads} -x map-ont {input.draft} {input.reads} > {output.paf}"

rule polish_raconI:
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
    threads: 20
    shell:
        """
        mkdir -p {params.outdir}
        racon -t {threads} {input.reads} {input.paf} {input.draft} > {output}
        """


rule map_for_raconII:
    input:
        reads = "result/{sample}/intermediate/nanopore/{sample}.fastq",
        draft = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon1.fasta"
    output:
        paf = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon2.paf"
    conda:
        "../../workflow/env/flye_polish_racon.yml"
    threads: 20
    shell:
        "minimap2 -t {threads} -x map-ont {input.draft} {input.reads} > {output.paf}"

rule polish_raconII:
    input:
        reads = "result/{sample}/intermediate/nanopore/{sample}.fastq",
        draft = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon1.fasta",
        paf = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon2.paf"
    output:
        "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon2.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_flye/polished/racon"
    conda:
        "../../workflow/env/flye_polish_racon.yml"
    threads: 20
    shell:
        """
        mkdir -p {params.outdir}
        racon -t {threads} {input.reads} {input.paf} {input.draft} > {output}
        """


rule map_for_raconIII:
    input:
        reads = "result/{sample}/intermediate/nanopore/{sample}.fastq",
        draft = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon2.fasta"
    output:
        paf = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon3.paf"
    conda:
        "../../workflow/env/flye_polish_racon.yml"
    threads: 20
    shell:
        "minimap2 -t {threads} -x map-ont {input.draft} {input.reads} > {output.paf}"

rule polish_raconIII:
    input:
        reads = "result/{sample}/intermediate/nanopore/{sample}.fastq",
        draft = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon2.fasta",
        paf = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon3.paf"
    output:
        "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon3.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_flye/polished/racon"
    conda:
        "../../workflow/env/flye_polish_racon.yml"
    threads: 20
    shell:
        """
        mkdir -p {params.outdir}
        racon -t {threads} {input.reads} {input.paf} {input.draft} > {output}
        """


rule map_for_raconIV:
    input:
        reads = "result/{sample}/intermediate/nanopore/{sample}.fastq",
        draft = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon3.fasta"
    output:
        paf = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon4.paf"
    conda:
        "../../workflow/env/flye_polish_racon.yml"
    threads: 20
    shell:
        "minimap2 -t {threads} -x map-ont {input.draft} {input.reads} > {output.paf}"

rule polish_raconIV:
    input:
        reads = "result/{sample}/intermediate/nanopore/{sample}.fastq",
        draft = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon3.fasta",
        paf = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon4.paf"
    output:
        "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon4.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_flye/polished/racon"
    conda:
        "../../workflow/env/flye_polish_racon.yml"
    threads: 20
    shell:
        """
        mkdir -p {params.outdir}
        racon -t {threads} {input.reads} {input.paf} {input.draft} > {output}
        """


rule map_for_raconV:
    input:
        reads = "result/{sample}/intermediate/nanopore/{sample}.fastq",
        draft = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon4.fasta"
    output:
        paf = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon5.paf"
    conda:
        "../../workflow/env/flye_polish_racon.yml"
    threads: 20
    shell:
        "minimap2 -t {threads} -x map-ont {input.draft} {input.reads} > {output.paf}"

rule polish_raconV:
    input:
        reads = "result/{sample}/intermediate/nanopore/{sample}.fastq",
        draft = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon4.fasta",
        paf = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon5.paf"
    output:
        "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon5.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_flye/polished/racon"
    conda:
        "../../workflow/env/flye_polish_racon.yml"
    threads: 20
    shell:
        """
        mkdir -p {params.outdir}
        racon -t {threads} {input.reads} {input.paf} {input.draft} > {output}
        """
