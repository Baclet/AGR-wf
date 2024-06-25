#Snakefile

import pandas as pd
from snakemake.io import glob_wildcards
import os

#damit werden die samples korrekt gefunden und zugeordnet
def find_samples(path):
    samples = set()
    pattern = re.compile(r'(calls_)?(MSC)(_hac_Q0)?\.fastq')
    for root, dirs, files in os.walk(path):
        for file in files:
            if file.endswith('.fastq'):
                match = pattern.match(file)
                if match:
                    samples.add(match.group(2))  # Group 2 is always 'MSC'
    return list(samples)


samples_illumina, = glob_wildcards("data/illumina/{sample}_1.fastq.gz")
samples_nano = find_samples("data/nanopore")
print(f"Illumina samples: {samples_illumina}")
print(f"Nanopore samples: {samples_nano}")

include: "workflow/rules/fastqc.smk"

#rule all in der alle Zieldateien Angegeben werden die erstellt werden sollen.
rule all:
    input:
        # Illumina FastQC Ausgaben
        expand("result/{sample}/quality_control/illumina/{sample}_{pair}_fastqc.html",
               sample=samples_illumina, pair=["1", "2"]),
        expand("result/{sample}/quality_control/illumina/{sample}_{pair}_fastqc.zip",
               sample=samples_illumina, pair=["1", "2"]),
        # Nanopore FastQC Ausgaben
        expand("result/{sample}/quality_control/nanopore/{sample}_fastqc.html",
               sample=samples_nano),
        expand("result/{sample}/quality_control/nanopore/{sample}_fastqc.zip",
               sample=samples_nano)
