# Snakefile

# import the config-file to do different assemblys (long-read or hybrid)
configfile: "workflow/config.yaml"

# import relevant packages:
import pandas as pd
from snakemake.io import glob_wildcards
import os
import re

# find the files in the specific folders (files with the ending .bam .fastq or .pod5 in the data/nanopore/{sample}/basecaller_output folder or/ and in the data/illumina folder
def find_samples(path):
    samples = set()
    for root, dirs, files in os.walk(path):
        for file in files:
            if file.endswith('.fastq') or file.endswith('.bam') or file.endswith('.pod5'):
                # extract "sample"-name
                sample_path = os.path.relpath(root, path)
                sample_name = sample_path.split(os.sep)[0]
                samples.add(sample_name)
    return list(samples)

samples_illumina, = glob_wildcards("data/illumina/{sample}_1.fastq.gz")
samples_nano = find_samples("data/nanopore")
print(f"Illumina samples: {samples_illumina}")
print(f"Nanopore samples: {samples_nano}")

# which assembly should be performed: 1. config: nano = true, hybrid = false; 2. config: nano = false, hybrid = true; 3. default 
if config["nano"] and not config["hybrid"]:
    include: "workflow/rules/nano_mode.smk"
elif not config["nano"] and config["hybrid"]:
    include: "workflow/rules/hybrid_mode.smk"
else:
    include: "workflow/rules/all_mode.smk"

# import all common rules
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

# rule all to create specific files
rule all:
    input:
        # nanopore FastQC
        expand("result/{sample}/quality_control/nanopore/{sample}_fastqc.html",
               sample=samples_nano),
        # nanopore FastQC after trimming
        expand("result/{sample}/quality_control/nanopore/{sample}_trimmed_fastqc.html",
               sample=samples_nano),
        # check the config settings: Which assembly should be done
        expand("result/{sample}/intermediate/flags/mode_check.txt",
               sample=samples_nano),
        # create QUAST-file
        expand("result/{sample}/intermediate/flags/quast_done.txt",
               sample=samples_nano),
        # perform BUSCO analyses
        expand("result/{sample}/final_genome/busco_results/",
               sample=samples_nano),
        # create the  busco_plot summary
        expand("result/{sample}/final_genome/busco_summaries/busco_figure.png",
               sample=samples_nano),
        # protein-prediction with AUGUSTUS 
        expand("result/{sample}/intermediate/flags/augustus_done.txt",
               sample=samples_nano),
        # do the clean_up (?)
        expand("result/{sample}/success.txt",
               sample=samples_nano)
