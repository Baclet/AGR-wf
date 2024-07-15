#!/bin/bash
# ----------------SLURM Parameters----------------
#SBATCH -p chaos
#SBATCH -n 38
#SBATCH --mem=240g
#SBATCH -N 1
#SBATCH --mail-user=pascal.daniel.baclet@bioinfsys.uni-giessen.de
#SBATCH --mail-type=END
#SBATCH -J AGR-wf
#SBATCH -D /homes/pbaclet/no_backup/AGR-wf
# ----------------Load Modules--------------------
# ----------------Commands------------------------
snakemake --use-conda --cores 35 --verbose
