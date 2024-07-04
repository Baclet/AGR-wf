# workflow/rules/flye_polish_racon.smk

# Import der benötigten Module
from snakemake.io import expand, glob_wildcards

# Regeln fürs polish der Nanopore Reads mit racon (funktioniert noch nicht)
rule map_for_racon:
    input:
        reads = "result/{sample}/intermediate/nanopore/{sample}.fastq",
	draft = "result/{sample}/intermediate/assembly_flye/medaka/{sample}_flye_medaka.fasta"
    output:
	map = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon1.paf"
    params:
        outdir = "result/{sample}/intermediate/assembly_flye/polished/racon"
    conda:
        "../../workflow/env/flye_polish_racon.yml"
    threads: 8
    shell:
        """
        mkdir -p {params.outdir}
        minimap2 -t {threads} -x map-ont "{input.draft}" "{input.reads}" > "{output.map}"
        """

rule polish_racon:
    input:
        reads = "result/{sample}/intermediate/nanopore/{sample}.fastq",
        draft = "result/{sample}/intermediate/assembly_flye/medaka/{sample}_flye_medaka.fasta",
	map = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon1.paf"
    output:
        racon_p = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon1.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_flye/polished/racon"
    conda:
        "../../workflow/env/flye_polish_racon.yml"
    threads: 8
    shell:
        """
        mkdir -p {params.outdir}
        racon -t {threads} "{input.reads}" "{input.map}" "{input.draft}" > "{output.racon_p}"
	"""
