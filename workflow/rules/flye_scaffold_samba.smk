# workflow/rules/flye_scaffold_samba.smk

# import sample names
from snakemake.io import expand, glob_wildcards

# rule to scaffold the flye_racon5_polca4_assembly with samba
rule flye_scaffold_sambaI:
    input:
        long_reads = "result/{sample}/intermediate/nanopore/{sample}.fastq",
        draft = "result/{sample}/intermediate/assembly_flye/polished/polca/{sample}_racon5_polca4.fasta"
    output:
        "result/{sample}/intermediate/assembly_flye/polished/samba/flye_racon_polca/{sample}_racon5_polca4_samba.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_flye/polished/samba/flye_racon_polca",
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
        mv *_racon5_polca4.fasta.scaffolds.fa {wildcards.sample}_racon5_polca4_samba.fasta
        cp {wildcards.sample}_racon5_polca4_samba.fasta ../../../../../../../{params.results}/{wildcards.sample}_polished.fasta
        """

# rule to scaffold the flye_racon5_assembly with samba
rule flye_scaffold_sambaII:
    input:
        long_reads = "result/{sample}/intermediate/nanopore/{sample}.fastq",
        draft = "result/{sample}/intermediate/assembly_flye/polished/polca/{sample}_racon5.fasta"
    output:
        "result/{sample}/intermediate/assembly_flye/polished/samba/flye_racon/{sample}_racon5_samba.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_flye/polished/samba/flye_racon"
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
        mv *_racon5.fasta.scaffolds.fa {wildcards.sample}_racon5_samba.fasta
        cp {wildcards.sample}_racon5_samba.fasta ../../../../../../../{params.results}/{wildcards.sample}_no_illumina_polished.fasta
	"""
