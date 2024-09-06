# workflow/rules/busco.smk
import glob
import os
from snakemake.io import expand, glob_wildcards

# Define busco_db path
BUSCO_DB_BASE = os.path.expanduser("~/busco_downloads/lineages")

# Rule to create the metrics with busco (Test) add mode check file.
rule quality_busco_all:
    input:
        genome_short = "result/{sample}/final_genome/{sample}_flye_no_illumina_polished.fasta", 
        genome_shortp = "result/{sample}/final_genome/{sample}_flye_polished.fasta", 
        genome_mas = "result/{sample}/final_genome/{sample}_masurca_polished.fasta",
	assembly_done = "result/{sample}/intermediate/flags/mode_check.txt"
    output:
        dir = directory("result/{sample}/final_genome/busco_results/"),
	flag = "result/{sample}/intermediate/flags/busco_done.txt"
    params:
        lineage = "fungi_odb10",
        db_path = BUSCO_DB_BASE
    conda:
        "../../workflow/env/busco.yml"
    threads: 40
    shell:
        """
        busco --version
        mkdir -p {output.dir}

        for genome in {input.genome_short} {input.genome_shortp} {input.genome_mas}; do
            base_name=$(basename $genome .fasta)
            out_dir="{output.dir}/$base_name"

            busco -i $genome \
                  -o $out_dir \
                  -m genome \
                  -l {params.lineage} \
                  --cpu {threads}
        done
	# Create flag
        touch {output.flag}
	"""
