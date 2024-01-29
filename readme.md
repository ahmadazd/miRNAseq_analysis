  

# miRNAseq analysis

  ## Scenario I
-**Sample 01:**  Reads are mostly found for the wildtype. no significant read counts at the edited site ( HDR) so the genotype is homologous wildtype ( WT/WT), no insertion occurred.
-**Sample 02:**  Reads are found in both sites the wildtype and the edited site (HDR) so the genotype is heterologous (WT/HDR), insertion happend only on one allele.
-**Sample 03:** Reads are mostly are found for the edited site ( HDR) with a gap at the guide RNA in the wildtype, so the genotype is homologous for the edited site (HDR) ( HDR/HDR), full insertion occurred at both alleles.
-**Sample 04:** Reads are mostly found for the wildtype. no significant read counts at the edited site ( HDR) so the genotype is homologous wildtype ( WT/WT), no insertion occurred.
 

 ## Scenario II
- **Objective 1:** The schematic (DAG) chart been generated using nextflow by adding the flag `-with-dag`. The chart is deposited in the directory `mirnaseq/DAG/flowchart_dag.png`

- **Objective 2&3:** The workflow has been written using Nextflow DSL2 workflow manger and nf-core template, 
- The workflow codes are in the folder `mirnaseq`  
- The output files are located in  `mirnaseq/results/`
- The raw read files (fastq files) are located in `mirnaseq/rawFiles/`
- The refrence files are located in `mirnaseq/ref_genome/`

The workflow process and the outputs are as following:

-  **FASTP_PROCESS:** Using fastp tool to quality score the fastq files and trim the truSeq adapter sequence that begins `TGGAATTCTCGGGTGCCAAGG`. 
*Notes*
*The output of this process found in  `mirnaseq/results/fastp_output/`*

-  **BOWTIE_PROCESS:** 
 -Alignment of the files in the output of the fastp (trimmed fastq files) with the mature miRNA fasta file (retrived from miRBASE database)  using `bowtie-build` and `bowtie` tools to produce SAM files for each fastq file. 
 -Convert the SAM files into BAM files using `samtools`. 
 *Notes*
 *The output of this process found in  `mirnaseq/results/aligmnet_output/`*

-  **MIRTOP_PROCESS:** 
-Annotate the resulted BAM files against the miRNA hairpin fasta file and miRNA human gff3 file retrived from miRBase using `mirtop gff` tool.
-Create the miRNA counts table using `mirtop counts` tool
*Notes*
*The output of this process found in  `mirnaseq/results/annotation_output/`*
*The counts table located in  `mirnaseq/results/annotation_output/mirtop.tsv`*
 
- **Objective 4:**
*NOTE......*
Due to an alignment issues that prevented bowtie tool from mapping the reference miRNA file, the resulting read counts were empty. As a consequence, we have generated an identical example read count file, maintaining the same format, to proceed with the normalization and visualization processes.

- The normalization and visualization script, input and output are located in the directory `normalization_visualization`
- The process has been done using python script `count_normlisation_visulisation.py` 
- The script produce normlized counts table `normalized_counts.tsv` and a heatmap `heatmap.png`
- The input file is an identical example of the mirtop read counts file `mirtop.tsv` 

#### Run the Workflow
- Standard
``nextflow run main.nf --rawRead_directory rawFiles``

- Using the workflow conda environment
``nextflow run main.nf --rawRead_directory rawFiles -profile conda``

- Using the workflow containers (Docker needs to be installed)
*Docker image can be build from the Dockerfile* `mirnaseq/Dockerfile` using the following command 
`docker build -t image_name -f mirnaseq/Dockerfile .`
*nextflow command with docker/singularity *
``nextflow run main.nf --rawRead_directory rawFiles -profile conda with-docker [docker image] or -with-singularity [singularity/docker image file]``
  
*NOTE...... The raw files (fastq) and the output of the fastp (fastq), bowtie(sam) and samtools(bam) are too big to be uploaded here!!!!!!!!!*