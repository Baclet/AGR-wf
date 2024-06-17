##workflow/rules/fastqc.smk

# Import der benötigten Module
from snakemake.io import expand, glob_wildcards

# Definition der Samples aus den Dateinamen
samples_illumina, = glob_wildcards("data/illumina/{sample}_1.fastq.gz")

#Regel für Illumina Reads
rule fastqc_short:
    input:
        sample = expand("data/illumina/{sample}_{pair}.fastq.gz", pair=["1", "2"], sample=samples_illumina)
    output:
        fastqc_html = "result/{sample}/quality_control/{sample}_{pair}_fastqc.html"
    params:
        directory = "result/{sample}/quality_control"
    conda:
        "../../workflow/env/fastqc.yml"  # Pfad zur Conda-Umgebungsdatei
    shell:
        """
        mkdir -p {params.directory} && fastqc -o {params.directory} {input.sample}
        """

#Regel für Nanopore Reads ### Das hier drunter funktioniert noch nicht. Keine fehlermeldung wird einfach nicht ausgeführt.

samples_nano, = glob_wildcards("data/nanopore/*/basecaller_output/{sample}.fastq")

rule fastqc_long:
    # Verwendung von fastqc zur Qualitätskontrolle für Nanopore-Daten
    input:
        sample = expand("data/nanopore/{sample}/basecaller_output/{sample}.fastq", sample=samples_nano)
    output:
        fastqc_html = "result/{sample}/quality_control/{sample}__fastqc.html"
    params:
        directory = "result/{sample}/quality_control"
    conda:
        "../../workflow/env/fastqc.yml"
    shell:
        """
        fastqc -o {params.directory} {input.sample}
        """

