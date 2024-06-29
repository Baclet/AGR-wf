# workflow/rules/assembly_nano.smk

# Import der benötigten Module
from snakemake.io import expand, glob_wildcards

# Regeln fürs assembly der Nanopore Reads move befehl definitiv noch fehlerhaft!
rule assembly_flye:
    input:
	nano = "result/{sample}/intermediate/nanopore/{sample}_trimmed.fastq"
    output:
        nano_assembly = "result/{sample}/intermediate/assembly_flye/{sample}_assembly.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_flye"
    conda:
        "../../workflow/env/assembly_flye.yml"
    threads: 8
    shell: 
        """
        mkdir -p {params.outdir}
        flye --nano-raw {input.nano} --out-dir {params.outdir} --threads {threads}
        mv {params.outdir}/assembly.fasta {output.nano_assembly}
	"""
