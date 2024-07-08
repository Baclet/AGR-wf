# workflow/rules/flye_polish_polca.smk

# import sample names
from snakemake.io import expand, glob_wildcards

# rule to polish the flye_racon5_assembly 4 x with polca
rule flye_polish_polcaI:
    input:
        r1 = "data/illumina/{sample}_1.fastq.gz",
        r2 = "data/illumina/{sample}_2.fastq.gz",
        draft = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon5.fasta"
    output:
        "result/{sample}/intermediate/assembly_flye/polished/polca/{sample}_racon5_polca1.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_flye/polished/polca"
    conda:
        "../../workflow/env/masurca.yml"
    threads: 50
    shell:
        """
        mkdir -p {params.outdir}
        polca.sh -a {input.draft} -r "{input.r1} {input.r2}" -t {threads}
        mv *_racon5*.PolcaCorrected.fa {output}
        rm *.fasta.*
        rm *.err
        """

rule flye_polish_polcaII:
    input:
        r1 = "data/illumina/{sample}_1.fastq.gz",
        r2 = "data/illumina/{sample}_2.fastq.gz",
        draft = "result/{sample}/intermediate/assembly_flye/polished/polca/{sample}_racon5_polca1.fasta"
    output:
        "result/{sample}/intermediate/assembly_flye/polished/polca/{sample}_racon5_polca2.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_flye/polished/polca"
    conda:
        "../../workflow/env/masurca.yml"
    threads: 50
    shell:
        """
        polca.sh -a {input.draft} -r "{input.r1} {input.r2}" -t {threads}
        mv *_racon5*.PolcaCorrected.fa {output}
        rm *.fasta.*
        rm *.err
        """

rule flye_polish_polcaIII:
    input:
        r1 = "data/illumina/{sample}_1.fastq.gz",
        r2 = "data/illumina/{sample}_2.fastq.gz",
        draft = "result/{sample}/intermediate/assembly_flye/polished/polca/{sample}_racon5_polca2.fasta"
    output:
        "result/{sample}/intermediate/assembly_flye/polished/polca/{sample}_racon5_polca3.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_flye/polished/polca"
    conda:
        "../../workflow/env/masurca.yml"
    threads: 50
    shell:
        """
        polca.sh -a {input.draft} -r "{input.r1} {input.r2}" -t {threads}
        mv *_racon5*.PolcaCorrected.fa {output}
        rm *.fasta.*
        rm *.err
        """

rule flye_polish_polcaIV:
    input:
        r1 = "data/illumina/{sample}_1.fastq.gz",
        r2 = "data/illumina/{sample}_2.fastq.gz",
        draft = "result/{sample}/intermediate/assembly_flye/polished/polca/{sample}_racon5_polca3.fasta"
    output:
        "result/{sample}/intermediate/assembly_flye/polished/polca/{sample}_racon5_polca4.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_flye/polished/polca"
    conda:
        "../../workflow/env/masurca.yml"
    threads: 50
    shell:
        """
        polca.sh -a {input.draft} -r "{input.r1} {input.r2}" -t {threads}
        mv *_racon5*.PolcaCorrected.fa {output}
        rm *.fasta.*
        rm *.err
        """
