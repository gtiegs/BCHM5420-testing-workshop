#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { DOWNLOAD_FASTQ } from './modules/download.nf'

workflow {
    // Read accessions from list and create channel
    accessions_ch = Channel
        .fromPath(params.accessions)
        .splitText()
        .map { it.trim() }
        .filter { it.length() > 0 }

    // Download FASTQ files from SRA
    DOWNLOAD_FASTQ(accessions_ch)
    
    // Collect all downloaded fastq files
    downloaded_files = DOWNLOAD_FASTQ.out.fastq.collect()

    // SRA-tools prefetch and fasterq-dump is complete
    downloaded_files.view { 
        "FASTQ file download completed."
    }
}