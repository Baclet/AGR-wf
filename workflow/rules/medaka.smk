# workflow/rules/medaka.smk

# mport the sample names
from snakemake.io import expand, glob_wildcards

# rule to create the consensus of the flye-assembly with Medaka
rule medaka_consensus:
    input:
        assembly = "result/{sample}/intermediate/assembly_flye/{sample}_assembly.fasta",
	reads = "result/{sample}/intermediate/nanopore/{sample}_trimmed.fastq"
    output:
        nano_assembly = "result/{sample}/intermediate/assembly_flye/medaka/{sample}_flye_medaka.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_flye/medaka"
    conda:
        "../../workflow/env/flye_medaka.yml"
    shell:
        """
        mkdir -p {params.outdir}
        medaka_consensus -i "{input.reads}" -d "{input.assembly}" -o "{params.outdir}" -b 100
        cp "{params.outdir}/consensus.fasta" "{output.nano_assembly}"
        """

