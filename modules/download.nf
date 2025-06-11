#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

/*
 * Download fastq files from the Sequence Read Archive (SRA)
 */

process DOWNLOAD_FASTQ {
    // Use SRA-tools container from Biocontainers
    container "quay.io/biocontainers/sra-tools:3.2.1--h4304569_0"
    
    tag "$accession"

    // Set output directory
    publishDir "${params.outdir}/fastq", mode: 'copy'

    input:
    val accession

    output:
    tuple val(accession), path("${accession}*.fastq.gz"), emit: fastq

    script:
    """
    # Create temp directory for SRA files
    mkdir -p ./sra_temp

    echo "Downloading ${accession}"

    # Download SRA files
    prefetch ${accession} --output-directory ./sra_temp

    # Convert SRA files to fastq
    fasterq-dump ./sra_temp/${accession}/${accession}.sra \\
        --outdir . \\
        --split-files \\
        --threads ${task.cpus}
    
    # Compress FASTQ files
    gzip *.fastq

    # Remove temp directory
    rm -rf ./sra_temp

    echo "Completed downloading ${accession}"
    """
}