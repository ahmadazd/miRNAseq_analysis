nextflow.enable.dsl=2
include { FASTP_PROCESS } from '../modules/fastp.nf'
include { BOWTIE_PROCESS } from '../modules/alignment.nf'
include { MIRTOP_PROCESS } from '../modules/annotation.nf'

workflow miRNASEQ_WORKFLOW {
    take:
        rawRead_directory
    
    main:
        // List all FASTQ files in the input directory
        fastq_files = Channel.fromPath("${rawRead_directory}/*.fastq*")
        // Use the fastp_process for each input FASTQ file for quality control and trimming 
        fastp_ch = FASTP_PROCESS(fastq_files)
        // List all the trimmed FASTQ files 
        fastp_files = Channel.fromPath("$PWD/results/fastp_output/*.fastq*")
        // Use the bowtie_process to align the mature miRNA fasta file to each trimmed FASTQ file
        bowtie_ch = BOWTIE_PROCESS(fastp_files, "$PWD/ref_genome/mature.fa")
        //collect all the aligned bam files
        bowtie_files = Channel.fromPath("$PWD/results/aligmnet_output/*.bam*").collect()
        // annotate the bam files to produce the counts file
        mirtop_ch = MIRTOP_PROCESS(bowtie_files, "$PWD/ref_genome/hsa.gff3", "$PWD/ref_genome/hairpin.fa")

    emit:
        fastp_ch.reads
        fastp_ch.json
        fastp_ch.html
        bowtie_ch.bam
        bowtie_ch.unmappedReads
        mirtop_ch.mirtop_gff
        mirtop_ch.mirtop_table
        mirtop_ch.mirtop_rawdata
}
// The workflow below has no function, its here for debugging purposes
workflow {

    miRNASEQ_WORKFLOW(params.rawRead_directory)
}
