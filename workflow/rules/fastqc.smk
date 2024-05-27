rule fastqc:
    # Uses fastqc to verify the quality of the reads
    input:
        sample = "data/illumina/MSC_1.fastq.gz"
    output:
        fastqc_html = "result/MSC/quality_control/MSC_fastqc.html",
        fastqc_zip = "result/MSC/quality_control/MSC_fastqc.zip"
    params:
        directory = "result/MSC/quality_control"
    conda:
        "../env/fastqc.yml"
    shell:
        "mkdir -p {params.directory} && fastqc -o {params.directory} {input}"
