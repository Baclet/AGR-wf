# AGR
## Einleitung

Dieses Projekt wurde im Rahmen eines Laborpraktikums erstellt und enthält den Workflow für die bioinformatischen Analysen für die Sequenzierung von Pilzen.
Das Projekt benötigt dazu die Sequenzierdaten von Nanopore und oder Illumina. Folgende Anwendung läuft nur unter Linux oder IOS für eine Verwendung in Windows ist die Installation von WSL notwendig.

## Verwendung
### Conda Environment

Die aktuellste Version von AGR ist verfügbar unter [github] (https://github.com/Baclet/AGR).

'git clone https://github.com/Baclet/AGR'

Das Conda Environment sollte wie folgt erstellt werden:

1. Installation von 'mamba' mit dem Befehl `conda install -n base --override-channels -c conda-forge mamba 'python_abi=*=*cp*'` siehe auch [mamba documentaiton](https://mamba.readthedocs.io/en/latest/mamba-installation.html).
2. Ausführen des Befehls `mamba env create --file environment.yaml` dieser Befehl erzeugt die notwendige Umgebung für 'AGR'.
3. Wechseln in die Umgebung 'AGR' mit dem Befehl 'mamba activate AGR'

