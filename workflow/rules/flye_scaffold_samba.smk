# workflow/rules/flye_scaffold_samba.smk

# import sample names
from snakemake.io import expand, glob_wildcards

# rule to scaffold the flye_racon5_polca4_assembly with samba
rule flye_scaffold_samba:
    input:
        long_read = = "result/{sample}/intermediate/nanopore/{sample}.fastq",
        draft = "result/{sample}/intermediate/assembly_flye/polished/polca/{sample}_racon5_polca4.fasta"
    output:
        "result/{sample}/intermediate/assembly_flye/polished/samba/{sample}_racon5_polca4_samba.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_flye/polished/polca"
    conda:
        "../../workflow/env/masurca.yml"
    threads: 50
    shell:
        """
        mkdir -p {params.outdir}
	cd {params.outdir}
        polca.sh -r ../../../../../../{input.draft} -q ../../../../../../{input.long_reads} -t {threads}
        """
