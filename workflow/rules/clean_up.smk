# workflow/rules/clean_up.smk
# delete all intermediate files:
import os

rule clean_up:    
    input:
        assembly = "result/{sample}/intermediate/flags/mode_check.txt",
        quast = "result/{sample}/intermediate/flags/quast_done.txt",
        buscoI = "result/{sample}/intermediate/flags/busco_done.txt",
        buscoII = "result/{sample}/intermediate/flags/busco_plot_done.txt",
        augustus = "result/{sample}/intermediate/flags/augustus_done.txt"
    output:
        "result/{sample}/success.txt"
    shell:
        """
#	 rm -r result/{wildcards.sample}/quality_control/
#        rm -r result/{wildcards.sample}/intermediate/
        touch result/{wildcards.sample}/success.txt
        echo "workflow finished!"
        """
