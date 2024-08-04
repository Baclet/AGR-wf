# workflow/rules/hybrid_mode.smk
# different modi different inputs:
import os

rule hybrid_mode:
    input:
        hybrid = "result/{sample}/intermediate/flags/flye_hybrid_done.txt",
        masurca = "result/{sample}/intermediate/flags/masurca_done.txt"
    output:
        "result/{sample}/intermediate/flags/mode_check.txt"
    shell:
        """
        touch result/{wildcards.sample}/intermediate/flags/mode_check.txt
        echo "assembly in hybrid mode"
        """
