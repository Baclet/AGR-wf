#workflow/rules/fastqc.smk
rule fastqc:
    # Verwendung von fastqc zur QC
    input:
        sample = expand("data/illumina/{sample}_{pair}.fastq.gz", pair=["1", "2"], sample=glob_wildcards("data/illumina/{sample}_*.fastq.gz").sample)
    output:
        fastqc_html = directory("result/{sample}/quality_control/{sample}_{pair}_fastqc.html"),
        fastqc_zip = directory("result/{sample}/quality_control/{sample}_{pair}_fastqc.zip")
    params:
        directory = "result/{sample}/quality_control"
    conda:
        "../../workflow/env/fastqc.yml"
    shell:
        "mkdir -p {params.directory} && fastqc -o {params.directory} {input.sample}"

