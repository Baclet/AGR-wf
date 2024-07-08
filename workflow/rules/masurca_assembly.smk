# workflow/rules/masurca_assembly.smk

# import required moduls
from snakemake.io import expand, glob_wildcards

# rule to assembl the nanopore & illumina Reads (neu Testphase)
rule masurca_assembly:
    input:
        r1 = "data/illumina/{sample}_1.fastq.gz",
        r2 = "data/illumina/{sample}_2.fastq.gz",
        long = "result/{sample}/intermediate/nanopore/{sample}.fastq"
    output:
        mas_assembly = "result/{sample}/intermediate/assembly_masurca/raw_assembly/{sample}_assembly.fasta"
    params:
        outdir = "result/{sample}/intermediate/assembly_masurca/raw_assembly",
        work_dir = "result/{sample}/intermediate/assembly_masurca/work_dir"
    conda:
        "../../workflow/env/masurca.yml"
    threads: 15
    shell:
        """
        mkdir -p {params.outdir}
        mkdir -p {params.work_dir}

        # create the config file
        cat << EOF > {params.work_dir}/config.txt
DATA
PE= pe 300 50 $(realpath {input.r1}) $(realpath {input.r2})
NANOPORE=$(realpath {input.long})
END

PARAMETERS
GRAPH_KMER_SIZE = auto
USE_LINKING_MATES = 0
LIMIT_JUMP_COVERAGE = 300
CA_PARAMETERS = ovlMerSize=30 cgwErrorRate=0.25 ovlMemory=4GB
KMER_COUNT_THRESHOLD = 1
NUM_THREADS = {threads}
JF_SIZE = 200000000
DO_HOMOPOLYMER_TRIM = 0
END
EOF

        # execute MaSuRCA
        cd {params.work_dir}
        masurca config.txt
        ./assemble.sh

        # move the output file
        find CA -name "primary.genome.scf.fasta" -exec mv {{}} {output.mas_assembly} \;
        """


# rule to assembl the nanopore & illumina Reads (old):
#rule masurca_assembly:
#    input:
#        r1 = "data/illumina/{sample}_1.fastq.gz",
#        r2 = "data/illumina/{sample}_2.fastq.gz",
#        long = "result/{sample}/intermediate/nanopore/{sample}.fastq"
#    output:
#        mas_assembly = "result/{sample}/intermediate/assembly_masurca/raw_assembly/{sample}_assembly.fasta"
#    params:
#        outdir = "result/{sample}/intermediate/assembly_masurca/raw_assembly"
#    conda:
#        "../../workflow/env/masurca.yml"
#    threads: 8
#    shell:
#        """
#        mkdir -p {params.outdir}
#        masurca -t {threads} -i {input.r1}, {input.r2} -r {input.long} -o {params.outdir}
#        mv "{params.outdir}/CA.*/primary.genome.scf.fasta" "{output.mas_assembly}"
#        """
