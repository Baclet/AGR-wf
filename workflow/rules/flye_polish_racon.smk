# workflow/rules/flye_polish_racon.smk

# Import der benötigten Module
from snakemake.io import expand, glob_wildcards

# Regeln fürs polish der Nanopore Reads mit racon (funktioniert noch nicht)
rule as_flye:
    input:
        reads = "result/{sample}/intermediate/nanopore/{sample}.fastq"
	draft = "result/{sample}/intermediate/assembly_flye/medaka/{sample}_flye_medaka.fasta"
    output:
        racon_p = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon1.fasta"
	map = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon1.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_flye/polished/racon"
    conda:
        "../../workflow/env/flye_polish_racon.yml"
    shell:
        """
        mkdir -p {params.outdir}
        
        mv "{params.outdir}/assembly.fasta" "{output.nano_assembly}"
        """

