# workflow/rules/assembly_nano.smk

# Import der benötigten Module
from snakemake.io import expand, glob_wildcards

# Regeln fürs assembly der Nanopore Reads move befehl definitiv noch fehlerhaft!
rule assembly_flye:
    input:
        "result/{sample}/intermediate/nanopore/{sample}_trimmed.fastq"
    output:
        nano_assembly = "result/{sample}/intermediate/assembly_flye/{sample}_assembly.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_flye"
    conda:
        "../../workflow/env/assembly_flye.yml"
    threads: 8
    log:
        "logs/assembly_flye/{sample}.log"
    shell:
        """
        set -e
        set -x
        echo "Current working directory: $(pwd)"
        echo "Input file: {input}"
        echo "Input file exists: $(ls -l {input})"
        echo "Output directory: {params.outdir}"
        echo "Threads: {threads}"
        
        mkdir -p {params.outdir}
        
        if [ -f "{input}" ]; then
            flye --nano-raw "{input}" --out-dir "{params.outdir}" --threads {threads} 2>&1 | tee {log}
            
            if [ -f "{params.outdir}/assembly.fasta" ]; then
                mv "{params.outdir}/assembly.fasta" "{output.nano_assembly}"
                echo "Assembly completed successfully."
            else
                echo "Flye did not produce assembly.fasta. Check the log file."
                exit 1
            fi
        else
            echo "Input file does not exist: {input}"
            exit 1
        fi
        """

