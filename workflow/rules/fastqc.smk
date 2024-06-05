# workflow/rules/fastqc.smk
rule fastqc:
    # Verwendung von fastqc zur QC
    input:
        fastq1="data/illumina/{sample}_1.fastq.gz",
        fastq2="data/illumina/{sample}_2.fastq.gz"
    output:
        fastqc_html = "result/{sample}/quality_control/{sample}_fastqc.html",
        fastqc_zip = "result/{sample}/quality_control/{sample}_fastqc.zip"
    params:
        directory = "result/{sample}/quality_control"
    conda:
        "workflow/env/fastqc.yml"
    shell:
        "mkdir -p {params.directory} && fastqc -o {params.directory} {input.fastq1} {input.fastq2}"
