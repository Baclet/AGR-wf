rule fastqc:
    # Verwendung von fastqc zur QC
    input:        
	sample="{sample}_1.fastq.gz",
               "{sample}_2.fastq.gz"
    output:
        fastqc_html = "result/{sample}/quality_control/{sample}_{pair}_fastqc.html",
        fastqc_zip = "result/{sample}/quality_control/{sample}_{pair}_fastqc.zip"
    params:
        directory = "result/{sample}/quality_control"
    conda:
        "../../workflow/env/fastqc.yml"
    shell:
        "mkdir -p {params.directory} && fastqc -o {params.directory} {input.sample}"
