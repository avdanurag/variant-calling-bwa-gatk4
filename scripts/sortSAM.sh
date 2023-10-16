#!/bin/bash

# Check if the required arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_dir> <output_dir>"
    exit 1
fi

# Get the paths from the command-line arguments
INPUT_DIR="$1"
OUTPUT_DIR="$2"


# Path to the gatk executable
GATK=/home/avd/mambaforge/pkgs/gatk4-4.4.0.0-py36hdfd78af_0/bin/gatk


# Sort order
SORT_ORDER="coordinate"

# Temporary directory
TMP_DIR=temp

# Process each SAM file in the input directory
for SAM in ${INPUT_DIR}/*.sam.gz
do
  # Extract the sample name from the file name
  SAMPLE_NAME=$(basename ${SAM} .sam.gz | cut -d'.' -f1-4)
  echo "Processing sample ${SAMPLE_NAME}"

  OUTPUT=${OUTPUT_DIR}/${SAMPLE_NAME}_sorted.bam

  ${GATK} --java-options "-Xmx50G" SortSam --INPUT ${SAM} --OUTPUT ${OUTPUT} --SORT_ORDER ${SORT_ORDER} --TMP_DIR ${TMP_DIR} &

  # Wait for a new job slot if the maximum parallel runs is reached
  if [[ $(jobs -r -p | wc -l) -ge ${NUM_RUNS} ]]; then
    wait -n
  fi
done

# Wait for all background jobs to finish
wait
