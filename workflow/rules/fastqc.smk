rule fastqc:
    # Verwendung von fastqc zur QC
    input:
        sample = "data/illumina/MSC_1.fastq.gz"
    output:
        fastqc_html = "result/MSC/quality_control/MSC_fastqc.html",
        fastqc_zip = "result/MSC/quality_control/MSC_fastqc.zip"
    params:
        directory = "result/MSC/quality_control"
    conda:
        "workflow/env/fastqc.yml"
    shell:
        "mkdir -p {params.directory} && fastqc -o {params.directory} {input.sample}"
