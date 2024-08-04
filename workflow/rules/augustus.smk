# workflow/rules/augustus.smk

# import sample names
import glob

# Create the .gff file:
rule predict_augustus:
    input:
        genomes = lambda wildcards: glob.glob(f"result/{wildcards.sample}/final_genome/*.fasta"),
# test input flag
        assembly_done = "result/{sample}/intermediate/flags/mode_check.txt"
    output:
        flag = "result/{sample}/intermediate/flags/augustus_done.txt"
    params:
        species = "coprinus",
        outdir = "result/{sample}/final_genome/augustus_output/"
    conda:
        "../../workflow/env/augustus.yml"
    shell:
        """
        mkdir -p {params.outdir}

        # Augustus-Prediction
        for genome in {input.genomes}; do
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
