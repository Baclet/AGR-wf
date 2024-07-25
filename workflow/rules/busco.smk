# workflow/rules/busco.smk

import glob
import os
from snakemake.io import expand, glob_wildcards

# Define busco_db path
BUSCO_DB_BASE = os.path.expanduser("~/busco_downloads/lineages")

# Rule to create the metrics with busco (Test)
rule busco_all:
    input:
        genomes = lambda wildcards: glob.glob(f"result/{wildcards.sample}/final_genome/*.fasta")
    output:
        directory("result/{sample}/final_genome/busco_results/")
    params:
        lineage = "fungi_odb10",
        db_path = BUSCO_DB_BASE
    conda:
        "../../workflow/env/busco.yml"
    threads: 50
    shell:
        """
        busco --version
        mkdir -p {output}

        for genome in {input.genomes}; do
            base_name=$(basename $genome .fasta)
            out_dir="{output}/$base_name"

            busco -i $genome \
                  -o $out_dir \
                  -m genome \
                  -l {params.lineage} \
#                  --force \
                  --cpu {threads}
        done
        """
