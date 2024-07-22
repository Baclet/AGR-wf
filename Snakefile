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
include: "workflow/rules/trim_short.smk"
include: "workflow/rules/trim_long.smk"
include: "workflow/rules/flye_assembly.smk"
include: "workflow/rules/medaka.smk"
include: "workflow/rules/flye_polish_racon.smk"
include: "workflow/rules/flye_polish_polca.smk"
include: "workflow/rules/flye_scaffold_samba_hybrid.smk"
include: "workflow/rules/flye_scaffold_samba_nano.smk"
include: "workflow/rules/masurca_assembly.smk"
include: "workflow/rules/masurca_polish_polca.smk"
include: "workflow/rules/masurca_scaffold_samba.smk"

#rule all in der alle Zieldateien Angegeben werden die erstellt werden sollen.
rule all:
    input:
        # Illumina FastQC Ausgaben
        expand("result/{sample}/quality_control/illumina/{sample}_{pair}_fastqc.html",
               sample=samples_illumina, pair=["1", "2"]),
        # Nanopore FastQC Ausgaben
        expand("result/{sample}/quality_control/nanopore/{sample}_fastqc.html",
               sample=samples_nano),
        # Illumina FastQC Ausgaben nach trimming
        expand("result/{sample}/quality_control/illumina/{sample}_{pair}_trimmed_fastqc.html",
               sample=samples_illumina, pair=["1", "2"]),
        # Nanopore FastQC Ausgaben nach trimming
        expand("result/{sample}/quality_control/nanopore/{sample}_trimmed_fastqc.html",
               sample=samples_nano),


        ### Mit der unteren Regel lässt sich steuern ob nur eine nanopore Seq durchgeführt wird. Add if rule
        # Ausführen flye-samba-scaffolding racon_polca (hybrid nanopore und illumina)
        expand("result/{sample}/intermediate/assembly_flye/polished/samba/flye_racon_polca/{sample}_racon5_polca4_samba.fasta",
            sample=samples_nano),
        # Ausführen flye-assembler mit polish nur racon (nur nanopore)
        expand("result/{sample}/intermediate/assembly_flye/polished/samba/flye_racon/{sample}_racon5_samba.fasta",
            sample=samples_nano),
        # Ausführen masurca-assembler mit polish und samba       
        expand("result/{sample}/intermediate/assembly_masurca/polished/samba/{sample}_polca4_samba.fasta",
            sample=samples_nano)
