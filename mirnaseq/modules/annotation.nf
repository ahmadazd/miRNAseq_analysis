// annotate to miRBase using mirtop
nextflow.enable.dsl=2
process MIRTOP_PROCESS {
    publishDir "results", mode: 'move'
    // Input: input BAM file
    input:
    path bam_file
    path miRBase_gff3_reference
    path hairpin

    output:
    path "annotation_output/mirtop.gff", emit: mirtop_gff
    path "annotation_output/mirtop.tsv", emit: mirtop_table
    path "annotation_output/mirtop_rawData.tsv", emit: mirtop_rawdata

    script:
    """
    # Create the output directory
    mkdir -p annotation_output

    # annotate the BAM file using mirtop
    mirtop gff --hairpin ${hairpin} --sps hsa -o annotation_output --gtf ${miRBase_gff3_reference} ${bam_file}
    mirtop counts --hairpin ${hairpin} --gtf ${miRBase_gff3_reference} -o annotation_output --sps hsa --add-extra --gff annotation_output/mirtop.gff
    mirtop export --format isomir --hairpin ${hairpin} --gtf ${miRBase_gff3_reference} --sps hsa -o annotation_output annotation_output/mirtop.gff

    """
}
