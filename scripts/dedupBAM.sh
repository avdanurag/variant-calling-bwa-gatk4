#!/bin/bash

# Check if the required arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_dir> <output_dir>"
    exit 1
fi

# Get the paths from the command-line arguments
INPUT_DIR="$1"
OUTPUT_DIR="$2"

# Define the number of parallel runs
NUM_RUNS=10

# Path to the gatk executable
GATK=gatk


# Process each sorted BAM file in the input directory
for BAM in ${INPUT_DIR}/*_sorted.bam
do
  # Extract the sample name from the file name
  SAMPLE_NAME=$(basename ${BAM} _sorted.bam | cut -d'-' -f1-4)
  echo "Processing sample ${SAMPLE_NAME}"

  # Output deduplicated BAM file
  OUTPUT=${OUTPUT_DIR}/${SAMPLE_NAME}_dedup.bam

  # Temporary directory
  TMP_DIR=/storage/Anurag/INVITE/pub_data/scripts/temp

  # Run MarkDuplicates
  ${GATK} --java-options "-Xmx200G" MarkDuplicates \
    --INPUT ${BAM} \
    --OUTPUT ${OUTPUT} \
    --METRICS_FILE ${OUTPUT_DIR}/${SAMPLE_NAME}_markduplicates_metrics.txt \
    --REMOVE_DUPLICATES true \
    --OPTICAL_DUPLICATE_PIXEL_DISTANCE 2500 \
    --CREATE_INDEX true \
    --TMP_DIR ${TMP_DIR} \
    --MAX_FILE_HANDLES_FOR_READ_ENDS_MAP 1000 &

  # Wait for a new job slot if the maximum parallel runs is reached
  if [[ $(jobs -r -p | wc -l) -ge ${NUM_RUNS} ]]; then
    wait -n
  fi
done

# Wait for all background jobs to finish
wait
