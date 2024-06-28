# workflow/rules/trim_short.smk

# Import der benötigten Module
from snakemake.io import expand, glob_wildcards

# Regeln für Illumina Reads
rule trim_short:
    input:
        r1 = "data/illumina/{sample}_1.fastq.gz",
	r2 = "data/illumina/{sample}_2.fastq.gz"
    output:
        r1_trimmed = "result/{sample}/intermediate/trimmed/{sample}_val_1.fq.gz",
	r2_trimmed = "result/{sample}/intermediate/trimmed/{sample}_val_2.fq.gz"
    params:
        outdir = "result/{sample}/intermediate/trimmed"
    conda:
        "../../workflow/env/trim.yml"
    shell:
        """
        mkdir -p {params.outdir}
        trim_galore --paired {input.r1} {input.r2} --cores 4 -q 20 -o {params.outdir}
        mv {params.outdir}/{wildcards.sample}_1_val_1.fq.gz {output.r1_trimmed}
        mv {params.outdir}/{wildcards.sample}_2_val_2.fq.gz {output.r2_trimmed}
	"""

rule fastqc_trimmed_short:
    input:
        "result/{sample}/intermediate/trimmed/{sample}_val_{pair}.fq.gz"
    output:
        html = "result/{sample}/quality_control/illumina/{sample}_{pair}_trimmed_fastqc.html",
        zip = "result/{sample}/quality_control/illumina/{sample}_{pair}_trimmed_fastqc.zip"    
    params:
        outdir = "result/{sample}/quality_control/illumina"
    conda:
        "../../workflow/env/trim.yml"
    shell:
        """
        mkdir -p {params.outdir}
        fastqc -o {params.outdir} {input}
        mv {params.outdir}/{wildcards.sample}_val_{wildcards.pair}_fastqc.zip {output.zip}
        mv {params.outdir}/{wildcards.sample}_val_{wildcards.pair}_fastqc.html {output.html}
        """
