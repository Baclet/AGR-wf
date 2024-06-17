# Snakefile
import pandas

include: "workflow/rules/fastqc.smk"

samples_illumina, = glob_wildcards("data/illumina/{sample}_1.fastq.gz")
#samples_nano, = glob_wildcards("data/nanopore/*/basecaller_output/{sample}.fastq")

#rule all in der alle Zieldateien Angegeben werden die erstellt werden sollen.
rule all:
    input:
        expand("result/{sample}/quality_control/{sample}_{pair}_fastqc.html",
               sample=samples_illumina, pair=["1", "2"])
#    input:
#        expand("result/{sample}/quality_control/{sample}__fastqc.html",
#               sample=samples_nano)
#
# Auskommentiert funktioniert im Moment nicht. Keine fehlermeldung aber das file wird nicht erstellt.
