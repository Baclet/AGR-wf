# Snakefile
import pandas

configfile: "workflow/.config.yaml"

include: "workflow/rules/fastqc.smk"
