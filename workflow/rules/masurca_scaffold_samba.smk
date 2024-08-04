# workflow/rules/masurca_scaffold_samba.smk

# import sample names
from snakemake.io import expand, glob_wildcards

# rule to scaffold the masurca_polca4_assembly with samba
rule masurca_scaffold_samba:
    input:
        long_reads = "result/{sample}/intermediate/nanopore/{sample}.fastq",
        draft = "result/{sample}/intermediate/assembly_masurca/polished/polca/{sample}_assembly_polca4.fasta"
    output:
        "result/{sample}/intermediate/assembly_masurca/polished/samba/{sample}_polca4_samba.fasta",
        "result/{sample}/intermediate/flags/masurca_done.txt"
    params:
        outdir = "result/{sample}/intermediate/assembly_masurca/polished/samba",
        results = "result/{sample}/final_genome"
    conda:
        "../../workflow/env/masurca.yml"
    threads: 50
    shell:
        """
        mkdir -p {params.outdir}
        mkdir -p {params.results}
        cd {params.outdir}
        samba.sh -r ../../../../../../{input.draft} -q ../../../../../../{input.long_reads} -t {threads}
        cp *_polca4.fasta.scaffolds.fa {wildcards.sample}_polca4_samba.fasta
        cp {wildcards.sample}_polca4_samba.fasta ../../../../../../{params.results}/{wildcards.sample}_masurca_polished.fasta
#Flags:
        mkdir -p ../../../../../../result/{wildcards.sample}/intermediate/flags
        touch ../../../../../../result/{wildcards.sample}/intermediate/flags/masurca_done.txt
        """
