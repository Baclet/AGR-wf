# workflow/rules/busco_plot.smk
import glob

# Plot the busco results:
rule busco_plot:
    input:
        summaries = lambda wildcards: glob.glob(f"result/{wildcards.sample}/final_genome/busco_results/*/short_summary*.txt")
    output:
        plot = "result/{sample}/final_genome/busco_summaries/busco_figure.png"
    params:
        summary_dir = "result/{sample}/final_genome/busco_summaries"
    conda:
        "../../workflow/env/busco_plot.yml"
    shell:
        """
        # create a folder and copy the summary
        mkdir -p {params.summary_dir}
        cp {input.summaries} {params.summary_dir}/

        # execute the plotting script
        cd {params.summary_dir}
        generate_plot.py -wd .
        """
