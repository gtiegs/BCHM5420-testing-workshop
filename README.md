# BCHM5420-testing-workshop
A repository meant to be cloned onto your computer for the BCHM5420 Reproducibility Testing Workshop. The goal of this tutorial is to test a command used to download fastq files from the [Sequence Read Archive (SRA)](https://www.ncbi.nlm.nih.gov/sra/) for a (very) small dataset. These files belong to the **PRJNA955174** project from the NCBI SRA.

## Installation

### Step 1: Set Up a Directory
First, create a directory where you want to clone the test repository.
```bash
mkdir -p test-workshop
cd <path to test-workshop>
```

### Step 2: Clone the Repository
Next, clone the repository.
```bash 
git clone https://github.com/gtiegs/BCHM5420-testing-workshop.git
```

## Environment set up
### Step 1: Create a Virtual Environment
We now need to set up a virtual environment to execute the command we want to test.
You can use `conda` or `mamba` to create an environment using the `environment.yml` file:
```bash
conda env create -f environment.yml
```
Or, if you prefer docker, **you can activate the class docker environment you've already set up.** It should work just as well!

### Step 2: Activate the Environment
Now that we have created an environment, we need to activate it.
```bash
conda activate 5420_16S_pipeline
```

## Repo Orientation
The repository is structured as follows:
```bash
test-workshop/
├── environment.yml
├── main.nf
├── nextflow.config
├── accession_list.csv
├── modules/
│   ├── download.nf
├── README.md
```

### .modules/download.nf
Lets take a look at the `.modules/download.nf` file:
```bash
cat modules/download.nf
```

This file is a Nextflow module, which defines the process **DOWNLOAD_FASTQ** which uses the commands following commands from the SRA Toolkit:
- `prefetch` to fetch the SRA files matching the accession IDs listed in the `accession_list.csv`.
- `fastq-dump` to download fastq files from the SRA files.
- `gzip` to compress the fastq files so that they can be used by downstream tools.

This process runs using a Biocontainers docker image for sra-tools: `"quay.io/biocontainers/sra-tools:3.2.1--h4304569_0"`

### main.nf
Now let's take a look at the `main.nf` file:
```bash
cat main.nf
```

The `main.nf` file defines the workflow, which calls the DOWNLOAD_FASTQ process. It then runs each accession ID in the `accession_list.csv` file through the `DOWNLOAD_FASTQ` process.

### accession_list.csv
Before running the workflow, let's check the contents of the `accession_list.csv` file:
```bash
cat accession_list.csv
```
This file contains the SRA accession IDs for two samples. These sample are for the same individual before and after cranberry extract supplementation. 

## Usage
To run this Nextflow workflow, all we need to do now is run the following command:

```bash
nextflow run main.nf -profile docker
```
Since I have pre-defined the parameters in the `nextflow.config` file, we don't need to specify any additional parameters.

## Results
The results of the workflow are stored in the `results` folder. This folder contains the compressed forwared and reverse fastq files for each sample, which can be found in the `fastq` folder:
```bash
ls results/fastq
```

There should be 4 files, 2 for each sample:
```
SRR24156318_1.fastq.gz  
SRR24156318_2.fastq.gz  
SRR24156319_1.fastq.gz  
SRR24156319_2.fastq.gz
```

 

