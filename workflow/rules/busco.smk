# workflow/rules/busco.smk

# import sample names
from snakemake.io import expand, glob_wildcards
# define busco_db path
BUSCO_DB_BASE = os.path.expanduser("~/busco_downloads/lineages")

# rule to create the metrics with busco (Test)
rule busco_all:
    output:
        directory("result/{sample}/final_genome/busco_results/")
    params:
        db_path = lambda wildcards: os.path.join(BUSCO_DB_BASE, "fungi_odb10"),
        lineage = "fungi_odb10"
    conda:
        "../../workflow/env/metrics.yml"
    threads: 20
    shell:
### check if DB is in path else download
        """
	if [ ! -d "{params.db_path}" ]; then
        echo "BUSCO database not found. Downloading..."
        busco --download {params.lineage}
        mkdir -p {BUSCO_DB_BASE}
        mv {params.lineage} {BUSCO_DB_BASE}/
        
	busco -i result/{sample}/final_genome/*.fasta -o {output} -m genome -l {params.db_path} --force --cpus {threads}
        """
