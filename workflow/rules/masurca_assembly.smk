# workflow/rules/masurca_assembly.smk

# Import der benötigten Module
from snakemake.io import expand, glob_wildcards

# rule to assembl the nanopore & illumina Reads
rule masurca_assembly:
    input:
        r1 = "data/illumina/{sample}_1.fastq.gz",
        r2 = "data/illumina/{sample}_2.fastq.gz",
        long = "result/{sample}/intermediate/nanopore/{sample}.fastq"
    output:
        mas_assembly = "result/{sample}/intermediate/assembly_masurca/raw_assembly/{sample}_assembly.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_masurca/raw_assembly"
    conda:
        "../../workflow/env/masurca_assembly.yml"
    threads: 8
    shell:
        """
        mkdir -p {params.outdir}
        masurca -t {threads} -i {input.r1}, {input.r2} -r {input.long} -o {params.outdir}
        mv "{params.outdir}/CA.*/primary.genome.scf.fasta" "{output.mas_assembly}"
        """
