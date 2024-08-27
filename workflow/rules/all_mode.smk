# workflow/rules/all_mode.smk
# this rule ensures the correct performance of the assembly depending on the hybrid nano or default configuration in the config file:
import os

rule all_mode:    
    input:
        nan = "result/{sample}/intermediate/flags/flye_nano_done.txt",
        hybrid = "result/{sample}/intermediate/flags/flye_hybrid_done.txt",
        masurca = "result/{sample}/intermediate/flags/masurca_done.txt"
    output:
        "result/{sample}/intermediate/flags/mode_check.txt"
    shell:
        """
        touch result/{wildcards.sample}/intermediate/flags/mode_check.txt
        echo "create all assemblies"
        """
