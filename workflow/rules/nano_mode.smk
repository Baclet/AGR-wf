# workflow/rules/nano_mode.smk
# this rule ensures the correct performance of the assembly depending on the nano configuration in the config file
import os

rule nano_mode:
    input:
        nan = "result/{sample}/intermediate/flags/flye_nano_done.txt"
    output:
        "result/{sample}/intermediate/flags/mode_check.txt"
    shell:
        """
        touch result/{wildcards.sample}/intermediate/flags/mode_check.txt
        echo "assemblies without illumina reads (nano mode)"
        """
