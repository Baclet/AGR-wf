# workflow/rules/basecaller.smk

# Import der benötigten Module
from snakemake.io import expand, glob_wildcards
import os

print(f"Process POD5 files and create BAM files using Dorado if necessary")

# Überprüfung der FASTQ-Existenz
def fastq_not_exists(wildcards):
    fastq_path = f"data/nanopore/{wildcards.sample}/basecaller_output/{wildcards.sample}.fastq"
    return not os.path.exists(fastq_path)


# Regel zum Basecalling wenn noch keine .bam datei vorhanden ist. Diese muss auf hac gändert werden
rule process_pod5_dorado:
    input:
        pod5_dir = "data/nanopore/{sample}/pod5"
    output:
        bam = "data/nanopore/{sample}/basecaller_output/{sample}.bam"
    params:
        output_dir = "data/nanopore/{sample}/basecaller_output"
    conda:
        "../../workflow/env/basecaller.yml"
    shell:
        """
        if [ ! -f {params.output_dir}/{wildcards.sample}.fastq ]; then
            mkdir -p {params.output_dir}
            dorado basecaller fast -v -x "cpu" --min-qscore 7 {input.pod5_dir} > {output.bam}
        else
            echo "FASTQ file already exists for {wildcards.sample}. Skipping Dorado basecalling."
            touch {output.bam}
        fi
        """


# Regel Erstellung der .fastq
rule copy_or_create_fastq:
    input:
        bam = "data/nanopore/{sample}/basecaller_output/{sample}.bam"
    output:
        fastq = "result/{sample}/intermediate/nanopore/{sample}.fastq",
        bam = "result/{sample}/intermediate/nanopore/{sample}.bam"
    params:
        outdir = "result/{sample}/intermediate/nanopore",
        input_fastq = "data/nanopore/{sample}/basecaller_output/{sample}.fastq"
    conda:
        "../../workflow/env/basecaller.yml"
    shell:
        """
        mkdir -p {params.outdir}
        cp {input.bam} {output.bam}
        if [ -f {params.input_fastq} ]; then
            cp {params.input_fastq} {output.fastq}
        else
            samtools bam2fq {output.bam} > {output.fastq}
        fi
	"""
