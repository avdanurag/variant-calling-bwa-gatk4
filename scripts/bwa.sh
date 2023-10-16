#!/bin/bash

# Check if the required arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <reference_dir> <input_dir> <output_dir>"
    exit 1
fi

# Get the paths from the command-line arguments
REF="$1"
INPUT_DIR="$2"
OUTPUT_DIR="$3"

# Path to the bwa executable
BWA=bwa

# Set the options for bwa
OPTIONS="-t 80"

# Process each pair of fastq files in the input directory
for R1_FILE in ${INPUT_DIR}/*_1_filt.fq.gz
do
  # Extract the sample name from the file name
  SAMPLE_NAME=$(basename ${R1_FILE} _1_filt.fq.gz | cut -d'_' -f1-4)
  echo "Processing sample ${SAMPLE_NAME}"

  # Build the paths to the input and output files
  R2_FILE=${INPUT_DIR}/${SAMPLE_NAME}_2_filt.fq.gz
  OUTPUT=${OUTPUT_DIR}/${SAMPLE_NAME}.sam.gz
  
  # Run bwa mem on the input fastq files and output the results to the output mapping file
  ${BWA} mem -M -R '@RG\tID:'${SAMPLE_NAME}'\tLB:'${SAMPLE_NAME}'\tPL:ILLUMINA\tPM:HISEQ\tSM:'${SAMPLE_NAME}'' ${REF} ${R1_FILE} ${R2_FILE} ${OPTIONS} | gzip -3 > ${OUTPUT}
  
done
