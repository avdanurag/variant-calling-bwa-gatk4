#!/bin/bash

# Check if the required arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_dir> <output_dir>"
    exit 1
fi

# Get the paths from the command-line arguments
INPUT_DIR="$1"
OUTPUT_DIR="$2"

# Path to the fastp executable
FASTP=fastp

# Set the options for fastp
OPTIONS="--thread 8 -q 30 -u 30 -l 70 --detect_adapter_for_pe -p -z 1"

# Process each pair of fastq files in the input directory
for R1_FILE in ${INPUT_DIR}/*_1.fastq
do
  # Extract the sample name from the file name
  SAMPLE_NAME=$(basename ${R1_FILE} _1.fastq | cut -d'_' -f1-4)
  echo "Processing sample ${SAMPLE_NAME}"

  # Build the paths to the input and output fastq files
  R2_FILE=${INPUT_DIR}/${SAMPLE_NAME}_2.fastq
  R1_OUTPUT=${OUTPUT_DIR}/${SAMPLE_NAME}_1_filt.fq.gz
  R2_OUTPUT=${OUTPUT_DIR}/${SAMPLE_NAME}_2_filt.fq.gz
  JSON_OUTPUT=${OUTPUT_DIR}/${SAMPLE_NAME}_fastp.json
  HTML_OUTPUT=${OUTPUT_DIR}/${SAMPLE_NAME}_fastp.html

  # Run fastp on the input fastq files and output the results to the output fastq files
  ${FASTP} -i ${R1_FILE} -I ${R2_FILE} -o ${R1_OUTPUT} -O ${R2_OUTPUT} \
           --json ${JSON_OUTPUT} --html ${HTML_OUTPUT} ${OPTIONS}
done

