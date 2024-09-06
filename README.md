# AGR-wf
## Einleitung

Dieses Projekt wurde im Rahmen eines Laborpraktikums erstellt und enthält den Workflow für die bioinformatischen Analysen für die Sequenzierung von Pilzen.
Mit dem Workflow werden die Sequenzen assembliert, annotiert und die entstandenen Genome einer Qualitätskontrolle unterzogen.
Der Workflow benötigt dazu die Sequenzierdaten von Nanopore und Illumina. Folgende Anwendung läuft nur unter Linux oder IOS für eine Verwendung in Windows ist die Installation von WSL notwendig.

## Verwendung von AGR-wf
### Installationsanweisung - Erzeugung des Conda Environments

Die aktuellste Version von AGR-wf ist verfügbar unter [github](https://github.com/Baclet/AGR-wf).

`git clone https://github.com/Baclet/AGR-wf`

Wechsle in den Ordner `AGR-wf`


Das Conda Environment sollte wie folgt erstellt werden:

1. Wenn noch nicht vorhanden Download und Installaton von `conda` z.B.: Wie folgt: `mkdir -p ~/miniconda3 && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh` und ausführen von `bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3`
2. Ausführen des Befehls `conda env create --file workflow/environment.yaml` dieser Befehl erzeugt die notwendige Umgebung für `AGR-wf`.
3. Installation von mamba mit `conda install -n base -c conda-forge mamba`
4. Wechseln in die Umgebung `AGR-wf` mit dem Befehl `conda activate AGR-wf`

### Ablage der Rohdaten

Die Rohdaten müssen in den Ordnern `data/nanopore` und `data/illumina` abgelegt werden. 

Illumina Sequenzen müssen in folgendem Format vorliegen (!): 
`data/illumina/{sample}_1.fastq.gz` und `data/illumina/{sample}_2.fastq.gz` 
also z. B. `data/illumina/FLA_1.fastq.gz` 


Nanopore Sequenzen müssen in folgendem Format vorliegen (!):
`data/nanopore/{sample}/pod5/xyz.pod5` 
also z. B. `data/nanopore/FLA/pod5/...`

Ebenfalls möglich ist die Ablage von `.fastq` oder `.bam` files nach dem Basecalling:
`data/nanopore/{sample}/basecaller_output/{sample}.bam` 
also `data/nanopore/FLA/basecaller_output/FLA.bam`

`data/nanopore/{sample}/basecaller_output/{sample}.fastq` 
also `data/nanopore/FLA/basecaller_output/FLA.fastq`

Andernfalls erfolgt das Basecalling im Rahmen des Workflows. Da der Workflow nicht auf einer GPU arbeitet ist die Auslagerung dieses Schrittes empfehlenswert. 


### Ausführung des AGR-wf

Zur Ausführung muss das Working directory `AGR-wf/` sein.

Der Workflow wird gestartet mit dem Befehl: `snakemake --use-conda --cores 40`
Die `-cores x` Option gibt die Anzahl der Kerne an und ist abhängig vom vorhandenen Computer. 
*Einschränkung: Eine kleine Anzahl an CPUs führt zu einem Abbruch. `AGR-wf` ist wurde auf 40 Kernen ausgelegt und getestet.*

Insbesondere wenn das Basecalling mit diesem Workflow ausgeführt werden soll empfiehlt sich die Verwendung eines SLURM-Clusters.
Hierfür muss das `snake.sh` File angepasst werden. Entsprechend der Konfiguration für den eigenen SLURM-Account und Ausführungspfad.
Die Ausführung erfolgt dann mit dem üblichen: `sbatch snake.sh` 

## Ergebnisse des Workflows
### Assemblierte Genome mit Flye und MaSuRCA

Alle *de-novo* Assemblies befinden sich in folgendem Ordner:
`result/{sample}/final_genome/`
Flye Assemblies ohne Illumina-Daten: `result/{sample}/final_genome/{sample}_no_illumina_polished.fasta`
Hybride Flye Assemblies mit polishing: `result/{sample}/final_genome/{sample}_polished.fasta`
Hybride MaSuRCA Assemblies: `result/{sample}/final_genome/{sample}{sample}_masurca_polished.fasta`

### Qualitätskontrolle mit QUAST und BUSCO

Die mit QUAST erzeugten deskriptiven Metriken befinden sich unter:
`result/{sample}/final_genome/quast_results/{sample}_report.html`
 
Alle mit BUSCO erzeugten Vollständigkeitsanalysen befinden sich unter:
`result/{sample}/final_genome/busco_results/`
oder als kombinierte Abbildung:
`result/{sample}/final_genome/busco_summaries/busco_figure.png`

### Genomannotation mit AUGUSTUS

Mit AUGUSTUS wurden die Genome annotiert und als `.gff` file ausgegeben:
`result/{sample}/final_genome/augustus_output/`

## Kontakt

Pascal Baclet - pascal.baclet@bioinfsys-uni-giessen.de
