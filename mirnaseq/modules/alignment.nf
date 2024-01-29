// Align to miRBase using Bowtie
nextflow.enable.dsl=2

process BOWTIE_PROCESS {
    publishDir "results", mode: 'move'
    input:
    path fastq_file
    path miRBase_reference

    // Output: Aligned BAM file
    output:
    path "aligmnet_output/${fastq_file.baseName.replaceAll(/\.fastq$/, '')}_aligned.bam", emit: bam
    path "aligmnet_output/${fastq_file.baseName.replaceAll(/\.fastq$/, '')}_unmapped.fq", emit: unmappedReads
    script:
    """
    # Create the output directory
    mkdir -p aligmnet_output

    # Build Bowtie index for the latest human reference annotation in miRBase
    bowtie-build ${miRBase_reference} aligmnet_output/miRBase_index

    # Align the FASTQ file using Bowtie
    bowtie -p 8 -k 50 --sam --best --strata -e 99999 --chunkmbs 2048 -x aligmnet_output/miRBase_index -q <(zcat ${fastq_file}) --un aligmnet_output/${fastq_file.baseName.replaceAll(/\.fastq$/, '')}_unmapped.fq -S > aligmnet_output/${fastq_file.baseName.replaceAll(/\.fastq$/, '')}_aligned.sam
    samtools view -bS aligmnet_output/${fastq_file.baseName.replaceAll(/\.fastq$/, '')}_aligned.sam > aligmnet_output/${fastq_file.baseName.replaceAll(/\.fastq$/, '')}_aligned.bam
    """
}
