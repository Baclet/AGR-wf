# workflow/rules/flye_assembly.smk

# import sample names
from snakemake.io import expand, glob_wildcards

# rulte to assembly the nanopore reads
rule flye_assembly:
    input:
        "result/{sample}/intermediate/nanopore/{sample}_trimmed.fastq"
    output:
        nano_assembly = "result/{sample}/intermediate/assembly_flye/{sample}_assembly.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_flye"
    conda:
        "../../workflow/env/flye_assembly.yml"
    threads: 50
    log:
        "logs/assembly_flye/{sample}.log"
    shell:
        """
        mkdir -p {params.outdir}
        flye --nano-raw "{input}" --out-dir "{params.outdir}" --threads {threads} 2>&1 | tee {log}
        mv "{params.outdir}/assembly.fasta" "{output.nano_assembly}"
        """

