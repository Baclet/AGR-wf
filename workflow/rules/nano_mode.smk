# workflow/rules/nano_mode.smk
# different modi different inputs:
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
