# workflow/rules/busco_plot.smk

# import sample names
import glob

# Plot the busco results:
rule quality_busco_plot:
    input:
        flag = "result/{sample}/intermediate/flags/busco_done.txt"
    output:
        flag = "result/{sample}/intermediate/flags/busco_plot_done.txt"
    conda:
        "../../workflow/env/busco.yml"
    shell:
        """
        mkdir -p result/{wildcards.sample}/final_genome/busco_summaries/
        # Copy the busco files in the folder
        for file in $(find result/{wildcards.sample}/final_genome/busco_results/ -name "short_summary*.txt"); do
            cp $file result/{wildcards.sample}/final_genome/busco_summaries/
        done
        # Create the plot
        generate_plot.py -wd result/{wildcards.sample}/final_genome/busco_summaries/
        # Create the flag
        touch {output.flag}
        """

