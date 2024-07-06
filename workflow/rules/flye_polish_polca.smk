# workflow/rules/flye_polish_polca.smk

# Import sample names
from snakemake.io import expand, glob_wildcards

# Rule to polish the flye_racon5_assembly 4x with polca ///Test wahrscheinlich fehler
rule flye_polish_polcaI:
    input:
        r1 = "data/illumina/{sample}_1.fastq.gz",
        r2 = "data/illumina/{sample}_2.fastq.gz",
        draft = "result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon5.fasta"
    output:
        "result/{sample}/intermediate/assembly_flye/polished/polcaI/{sample}_racon5_polcaI.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_flye/polished/polcaI"
    conda:
        "../../workflow/env/masurca.yml"
    shell:
        """
        mkdir -p {params.outdir}
        polca.sh -a {input.draft} -r "{input.r1} {input.r2}"
        mv ""result/{sample}/intermediate/assembly_flye/polished/racon/{sample}_racon5.fasta.PolcaCorrected.fa" "{output}"
        """

### polca.sh -a output_polca/ARM/ARM_hac_Q0_flye+medaka_racon5_Polca1.fa 
### -r "raw_data/ARM/ARM_1.fastq.gz raw_data/ARM/ARM_2.fastq.gz"
### && mv ARM_hac_Q0_flye+medaka_racon5_Polca1.fa.PolcaCorrected.fa output_polca/ARM/ARM_hac_Q0_flye+medaka_racon5_Polca2.fa
