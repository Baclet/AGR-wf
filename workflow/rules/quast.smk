# workflow/rules/quast.smk

# import sample names
from snakemake.io import expand, glob_wildcards

# rule to create the metrics with quast
rule quast_all:
    input:
        long_reads = "result/{sample}/final_genome/{sample}_*.fasta"
    output:
        "result/{sample}/final_genome/quast_results/{sample}_report.html"
    params:
        "result/{sample}/final_genome"
    conda:
        "../../workflow/env/metrics.yml"
    threads: 5
    shell:
        """
	cd {params}
        quast *.fasta
        mv quast_results/results_*/report.html quast_results/{wildcards.sample}_report.html
        """
