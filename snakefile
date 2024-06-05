import pandas

configfile: "workflow/.config.yaml"

include: "workflow/rules/fastqc.smk"

# Hauptregel, um den Workflow auszuführen
rule all:
    input:
        "result/MSC/quality_control/MSC_fastqc.html",
        "result/MSC/quality_control/MSC_fastqc.zip
