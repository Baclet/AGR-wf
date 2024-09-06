# workflow/rules/masurca_polish_polca.smk

# import sample names
from snakemake.io import expand, glob_wildcards

# rule to polish the masurca_assembly 4 x with polca
rule masurca_polish_polcaI:
    input:
        r1 = "data/illumina/{sample}_1.fastq.gz",
        r2 = "data/illumina/{sample}_2.fastq.gz",
        draft = "result/{sample}/intermediate/assembly_masurca/raw_assembly/{sample}_assembly.fasta"
    output:
        "result/{sample}/intermediate/assembly_masurca/polished/polca/{sample}_assembly_polca1.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_masurca/polished/polca"
    conda:
        "../../workflow/env/masurca.yml"
    threads: 40
    shell:
        """
        mkdir -p {params.outdir}
        cd {params.outdir}
        polca.sh -a ../../../../../../{input.draft} -r "../../../../../../{input.r1} ../../../../../../{input.r2}" -t {threads}
        mv *_assembly*.PolcaCorrected.fa {wildcards.sample}_assembly_polca1.fasta
        rm *.fasta.*
        rm *.err
        """

rule masurca_polish_polcaII:
    input:
        r1 = "data/illumina/{sample}_1.fastq.gz",
        r2 = "data/illumina/{sample}_2.fastq.gz",
        draft = "result/{sample}/intermediate/assembly_masurca/polished/polca/{sample}_assembly_polca1.fasta"
    output:
        "result/{sample}/intermediate/assembly_masurca/polished/polca/{sample}_assembly_polca2.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_masurca/polished/polca"
    conda:
        "../../workflow/env/masurca.yml"
    threads: 40
    shell:
        """
        cd {params.outdir}
        polca.sh -a ../../../../../../{input.draft} -r "../../../../../../{input.r1} ../../../../../../{input.r2}" -t {threads}
        mv *_assembly*.PolcaCorrected.fa {wildcards.sample}_assembly_polca2.fasta
        rm *.fasta.*
        rm *.err
        """

rule masurca_polish_polcaIII:
    input:
        r1 = "data/illumina/{sample}_1.fastq.gz",
        r2 = "data/illumina/{sample}_2.fastq.gz",
        draft = "result/{sample}/intermediate/assembly_masurca/polished/polca/{sample}_assembly_polca2.fasta"
    output:
        "result/{sample}/intermediate/assembly_masurca/polished/polca/{sample}_assembly_polca3.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_masurca/polished/polca"
    conda:
        "../../workflow/env/masurca.yml"
    threads: 40
    shell:
        """
        cd {params.outdir}
        polca.sh -a ../../../../../../{input.draft} -r "../../../../../../{input.r1} ../../../../../../{input.r2}" -t {threads}
        mv *_assembly*.PolcaCorrected.fa {wildcards.sample}_assembly_polca3.fasta
        rm *.fasta.*
        rm *.err
        """

rule masurca_polish_polcaIV:
    input:
        r1 = "data/illumina/{sample}_1.fastq.gz",
        r2 = "data/illumina/{sample}_2.fastq.gz",
        draft = "result/{sample}/intermediate/assembly_masurca/polished/polca/{sample}_assembly_polca3.fasta"
    output:
        "result/{sample}/intermediate/assembly_masurca/polished/polca/{sample}_assembly_polca4.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_masurca/polished/polca"
    conda:
        "../../workflow/env/masurca.yml"
    threads: 40
    shell:
        """
        cd {params.outdir}
        polca.sh -a ../../../../../../{input.draft} -r "../../../../../../{input.r1} ../../../../../../{input.r2}" -t {threads}
        mv *_assembly*.PolcaCorrected.fa {wildcards.sample}_assembly_polca4.fasta
        rm *.fasta.*
        rm *.err
        """
