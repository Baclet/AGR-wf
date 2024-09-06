# workflow/rules/augustus.smk

# import sample names
import glob

# Create the .gff file:
rule predict_augustus:
    input:
        genome_short = "result/{sample}/final_genome/{sample}_flye_no_illumina_polished.fasta",
        genome_shortp = "result/{sample}/final_genome/{sample}_flye_polished.fasta",
        genome_mas = "result/{sample}/final_genome/{sample}_masurca_polished.fasta",
        assembly_done = "result/{sample}/intermediate/flags/mode_check.txt"
    output:
        flag = "result/{sample}/intermediate/flags/augustus_done.txt",
    params:
        species = "coprinus",
        outdir = "result/{sample}/final_genome/augustus_output/"
    conda:
        "../../workflow/env/augustus.yml"
    shell:
        """
        mkdir -p {params.outdir}
        
        # Augustus-Prediction
        for genome in {input.genome_short} {input.genome_shortp} {input.genome_mas}; do
            base_name=$(basename "$genome" .fasta)
            out_file="{params.outdir}/${{base_name}}_augustus.gff"
            
            augustus --species={params.species} \
                     --gff3=on \
                     --outfile=$out_file \
                     $genome
        done

        # Create the flag
        touch {output.flag}
        """
