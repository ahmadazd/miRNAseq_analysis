nextflow.enable.dsl=2 
process FASTP_PROCESS {
    publishDir "results", mode: 'move'
    // Input: Single input FASTQ file
    input:
        path fastq_file

    output:
        path "fastp_output/${fastq_file.baseName.replaceAll(/\.fastq$/, '')}_fastp.fastq.gz", emit: reads
        path "fastp_output/${fastq_file.baseName.replaceAll(/\.fastq$/, '')}_fastp.json", emit: json
        path "fastp_output/${fastq_file.baseName.replaceAll(/\.fastq$/, '')}_fastp.html", emit: html

    script:
    """
    # Create the output directory
    mkdir -p fastp_output

    # Run Fastp on the input FASTQ file
        fastp -i ${fastq_file} -o fastp_output/${fastq_file.baseName.replaceAll(/\.fastq$/, '')}_fastp.fastq.gz --json fastp_output/${fastq_file.baseName.replaceAll(/\.fastq$/, '')}_fastp.json --html fastp_output/${fastq_file.baseName.replaceAll(/\.fastq$/, '')}_fastp.html --adapter_sequence=TGGAATTCTCGGGTGCCAAGG
    """
}
