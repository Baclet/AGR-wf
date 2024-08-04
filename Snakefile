# Snakefile

#referenziere config file:
configfile: "workflow/config.yaml"

#importiere entsprechende packages:
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
    return list(samples)

samples_illumina, = glob_wildcards("data/illumina/{sample}_1.fastq.gz")
samples_nano = find_samples("data/nanopore")
print(f"Illumina samples: {samples_illumina}")
print(f"Nanopore samples: {samples_nano}")

# Definiert die zu verwendenden Regeln basierend auf den Konfigurationseinstellungen (Sagt welches Assembly ausgeführt werden soll)
if config["nano"] and not config["hybrid"]:
    include: "workflow/rules/nano_mode.smk"
elif not config["nano"] and config["hybrid"]:
    include: "workflow/rules/hybrid_mode.smk"
else:
    include: "workflow/rules/all_mode.smk"

# hinzufügen aller gemeinsamer rules
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
include: "workflow/rules/quast.smk"
include: "workflow/rules/busco.smk"
include: "workflow/rules/busco_plot.smk"
include: "workflow/rules/augustus.smk"
include: "workflow/rules/clean_up.smk"

#rule all in der alle Zieldateien Angegeben werden die erstellt werden sollen.
rule all:
    input:
        # Nanopore FastQC Ausgaben
        expand("result/{sample}/quality_control/nanopore/{sample}_fastqc.html",
               sample=samples_nano),
        # Nanopore FastQC Ausgaben nach trimming
        expand("result/{sample}/quality_control/nanopore/{sample}_trimmed_fastqc.html",
               sample=samples_nano),
        # Test der config Einstellung: Welches Assembly ausgeführt werden soll
        expand("result/{sample}/intermediate/flags/mode_check.txt",
               sample=samples_nano),
        # Ausführen von quast (test mit flag.txt output)
        expand("result/{sample}/intermediate/flags/quast_done.txt",
               sample=samples_nano),
        # Ausführen von busco_plot
        expand("result/{sample}/intermediate/flags/busco_plot_done.txt",
               sample=samples_nano),
        # Ausführen von augustus 
        expand("result/{sample}/intermediate/flags/augustus_done.txt",
               sample=samples_nano),
        # Ausführen von clean_up 
        expand("result/{sample}/success.txt",
               sample=samples_nano)
        # Auskommentierte Regeln können hier als Kommentare bleiben
#        expand("result/{sample}/intermediate/flags/quast_done.txt",
#               sample=samples_nano),
#        expand("result/{sample}/final_genome/quast_results/{sample}_report.html",
#               sample=samples_nano),
        # expand("result/{sample}/final_genome/busco_summaries/busco_figure.png", sample=samples_nano),
        # expand("result/{sample}/final_genome/busco_results/", sample=samples_nano),
