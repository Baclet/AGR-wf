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

	# Ausführen der Rule medaka kann später weg
        expand("result/{sample}/intermediate/assembly_flye/medaka/{sample}_flye_medaka.fasta",
                sample=samples_nano),
	# Ausführen der polish steps mit racon kann später weg
        expand("result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon5.fasta",
	    sample=samples_nano),
        # Ausführen polca-polish flye kann später weg
        expand("result/{sample}/intermediate/assembly_flye/polished/polca/{sample}_racon5_polca4.fasta",
            sample=samples_nano),
	### Mit der unteren Regel lässt sich steuern ob nur eine nanopore Seq durchgeführt wird. Add if rule
        # Ausführen flye-samba-scaffolding racon_polca + just_racon Erstelle alle Flye-assemblys (Polishing nanopore + illumina and just nanopore)
        expand("result/{sample}/intermediate/assembly_flye/polished/samba/flye_racon_polca/{sample}_racon5_polca4_samba.fasta",
            sample=samples_nano),
        expand("result/{sample}/intermediate/assembly_flye/polished/samba/flye_racon/{sample}_racon5_samba.fasta",
            sample=samples_nano)

	# Ausführen Masurca-assembly (Test)
#        expand("result/ARM/intermediate/assembly_masurca/raw_assembly/ARM_assembly.fasta",
#            sample=samples_nano)
### Masurca-assembly hier aktuell nur ARM statt {sample} bedingt durch einen Fehler

	# Ausführen masurca-polish-polca (Test)
#        expand("result/ARM/intermediate/assembly_masurca/polished/polca/ARM_assembly_polca1.fasta",
#            sample=samples_nano)
