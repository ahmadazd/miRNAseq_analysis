// See the NOTICE file distributed with this work for additional information
// regarding copyright ownership.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
nextflow.enable.dsl=2

//default params
params.help = false

// mandatory params
params.rawRead_directory = null


// Print usage
def helpMessage() {
  log.info """
        Usage:
        The typical command for running the pipeline is as follows:
        nextflow run main.nf --rawRead_directory rawFiles

        Mandatory arguments:
        --rawRead_directory              The path for the raw read files ( fastq files)

        Optional arguments:
        --help                         This usage statement.
        """
}

// Show help message
if (params.help) {
    helpMessage()
    exit 0
}

assert params.rawRead_directory, "Parameter 'rawRead_directory' is not specified"

// Import modules/subworkflows
include { miRNASEQ_WORKFLOW } from './workflow/workflow.nf'

// Run main workflow
workflow {
    main:
    miRNASEQ_WORKFLOW(params.rawRead_directory)}
