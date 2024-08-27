# workflow/rules/flye_scaffold_samba_nano.smk

# import sample names
from snakemake.io import expand, glob_wildcards

# rule to scaffold the flye_racon5_assembly with samba
# test expliziter output name für einmal workflow (erste zeile nach ouput sieh eunteren)
rule flye_scaffold_samba_nanopore:
    input:
        long_reads = "result/{sample}/intermediate/nanopore/{sample}.fastq",
        draft = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon5.fasta"
    output:
        "result/{sample}/final_genome/{sample}_flye_no_illumina_polished.fasta",
        "result/{sample}/intermediate/assembly_flye/polished/samba/flye_racon/{sample}_racon5_samba.fasta",
        "result/{sample}/intermediate/flags/flye_nano_done.txt"
    params:
        outdir = "result/{sample}/intermediate/assembly_flye/polished/samba/flye_racon",
        results = "result/{sample}/final_genome"
    conda:
        "../../workflow/env/masurca.yml"
    threads: 50
    shell:
        """
        mkdir -p {params.outdir}
        mkdir -p {params.results}
	cd {params.outdir}
        samba.sh -r ../../../../../../../{input.draft} -q ../../../../../../../{input.long_reads} -t {threads}
        cp *_racon5.fasta.scaffolds.fa {wildcards.sample}_racon5_samba.fasta
        cp {wildcards.sample}_racon5_samba.fasta ../../../../../../../{params.results}/{wildcards.sample}_flye_no_illumina_polished.fasta
# create flags to check if the step was performed:
        mkdir -p ../../../../../../../result/{wildcards.sample}/intermediate/flags
        touch ../../../../../../../result/{wildcards.sample}/intermediate/flags/flye_nano_done.txt
	"""
