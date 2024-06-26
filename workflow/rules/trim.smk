# workflow/rules/trim.smk

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
### in der fastqc_trimmed_short ist noch ein fehler dannach auch die echo und ls befehle löschen
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
        echo "Debug: sample={wildcards.sample}, pair={wildcards.pair}"
        echo "Debug: input file={input}"
        echo "Debug: output dir={params.outdir}"
        mkdir -p {params.outdir}
        fastqc -o {params.outdir} {input}
        mv {params.outdir}/{wildcards.sample}_val_{wildcards.pair}_fastqc.zip {output.zip}
        mv {params.outdir}/{wildcards.sample}_val_{wildcards.pair}_fastqc.html {output.html}
        echo "FastQC completed. Checking output:"
        ls -l {params.outdir}
        """

# Regel für Nanopore Reads
#rule trim_long:
#    input:
#        "result/{sample}/intermediate/nanopore/{sample}.fastq"
#    output:
#        "result/{sample}/intermediate/nanopore/{sample}_trimmed.fastq"
#    params:
#        outdir = "result/{sample}/intermediate/nanopore"
#    conda:
#        "../../workflow/env/trim.yml"
#    shell:
#        "porechop -i {input} -o {output}"


#rule fastqc_trimmed_long:
#    input:
#        "result/{sample}/intermediate/nanopore/{sample}_trimmed.fastq"
#    output:
#        html = "result/{sample}/quality_control/nanopore/{sample}_trimmed_fastqc.html",
#        zip = "result/{sample}/quality_control/nanopore/{sample}_trimmed_fastqc.zip"
#    params:
#        outdir = "result/{sample}/quality_control/nanopore"
#    conda:
#        "../../workflow/env/trim.yml"
#    shell:
#        "fastqc -o {params.outdir} {input}"
