# workflow/rules/basecaller.smk

# import samlpe names
from snakemake.io import expand, glob_wildcards
import os

# check if FASTQ existes
def fastq_not_exists(wildcards):
    fastq_path = f"data/nanopore/{wildcards.sample}/basecaller_output/{wildcards.sample}.fastq"
    return not os.path.exists(fastq_path)


# rule to do the basecalling if no .bam file is avalible
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
            dorado basecaller hac -v -x "cpu" --min-qscore 7 {input.pod5_dir} > {output.bam}
        else
            echo "FASTQ file already exists for {wildcards.sample}. Skipping Dorado basecalling."
            touch {output.bam}
        fi
        """


# rule to create .fastq files
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
