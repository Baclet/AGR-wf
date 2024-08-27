# workflow/rules/augustus.smk

# import sample names
import glob

# Create the .gff file:
rule predict_augustus:
    input:
# test expliziter input name (genome_short funktionierte)
        genome_short = "result/{sample}/final_genome/{sample}_flye_no_illumina_polished.fasta",
        genome_shortp = "result/{sample}/final_genome/{sample}_flye_polished.fasta",
        genome_mas = "result/{sample}/final_genome/{sample}_masurca_polished.fasta",
#        genomes = lambda wildcards: glob.glob(f"result/{wildcards.sample}/final_genome/*.fasta"),
# test input flag
        assembly_done = "result/{sample}/intermediate/flags/mode_check.txt"
    output:
        flag = "result/{sample}/intermediate/flags/augustus_done.txt",
# test mit expilzitem output (funktionierte nicht ggf. mit explizitem input testen siehe busco) :
#        annotat = "result/{sample}/final_genome/augustus_output/{sample}_no_illumina_polished_augustus.gff"
# folgendes funktioniert nur mit zweiter ausführung:
#	annotat = "result/{sample}/final_genome/augustus_output/{sample}*_augustus.gff"
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
