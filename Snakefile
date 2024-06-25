# Snakefile

import pandas as pd
from snakemake.io import glob_wildcards
import os
import re

# Auffinden der samples (Endung .bam .fastq oder im Ordner in dem sich die .pod5 Dateien befinden)
def find_samples(path):
    samples = set()
    for root, dirs, files in os.walk(path):
        for file in files:
            if file.endswith('.fastq') or file.endswith('.bam') or file.endswith('.pod5'):
                # Extrahiere den Sample-Namen aus dem Pfad
                sample_path = os.path.relpath(root, path)
                sample_name = sample_path.split(os.sep)[0]  # Nimm den ersten Teil des relativen Pfads
                samples.add(sample_name)
                print(f"Found sample: {sample_name} in file: {file}")  # Debugging
    print(f"All found samples: {samples}")
    return list(samples)

samples_illumina, = glob_wildcards("data/illumina/{sample}_1.fastq.gz")
samples_nano = find_samples("data/nanopore")
print(f"Illumina samples: {samples_illumina}")
print(f"Nanopore samples: {samples_nano}")

# hinzufügen aller rules
include: "workflow/rules/fastqc.smk"
include: "workflow/rules/basecaller.smk"

#rule all in der alle Zieldateien Angegeben werden die erstellt werden sollen.
rule all:
    input:
        # Illumina FastQC Ausgaben
        expand("result/{sample}/quality_control/illumina/{sample}_{pair}_fastqc.html",
               sample=samples_illumina, pair=["1", "2"]),
        expand("result/{sample}/quality_control/illumina/{sample}_{pair}_fastqc.zip",
               sample=samples_illumina, pair=["1", "2"]),
        # Nanopore FastQC Ausgaben funktioniert nicht lokal daher ###
###        expand("result/{sample}/quality_control/nanopore/{sample}_fastqc.html",
###               sample=samples_nano),
###        expand("result/{sample}/quality_control/nanopore/{sample}_fastqc.zip",
###               sample=samples_nano),
	#Test Erstellung der .fastq-Files in /intermediate / "basecalling"
	expand("result/{sample}/intermediate/nanopore/{sample}.fastq",
               sample=samples_nano)
