#!/bin/bash

# Check if the required arguments are provided
if [ "$#" -ne 5 ]; then
    echo "Usage: $0 <reference_genome> <input_dir> <output_dir> <tmp_dir> <num_runs>"
    exit 1
fi

# Get the paths from the command-line arguments
GATK=gatk
Ref="$1"
INPUT_DIR="$2"
OUTPUT_DIR="$3"
TMP_DIR="$4"
NUM_RUNS="$5"

# Process each sorted BAM file in the input directory
for BAM in "${INPUT_DIR}"/*_dedup.bam; do
  # Extract the sample name from the file name
  SAMPLE_NAME=$(basename "${BAM}" _sorted.bam | cut -d'-' -f1-4)
  echo "Processing sample ${SAMPLE_NAME}"

  # Output gVCF file
  OUTPUT="${OUTPUT_DIR}/${SAMPLE_NAME}.g.vcf"

  # Run HaplotypeCaller in the background
  "${GATK}" --java-options '-XX:ParallelGCThreads=40' HaplotypeCaller \
    -R "${Ref}" \
    -I "${BAM}" \
    -O "${OUTPUT}" \
    -ERC GVCF &

  # Wait for a new job slot if the maximum parallel runs is reached
  if [[ $(jobs -r -p | wc -l) -ge ${NUM_RUNS} ]]; then
    wait -n
  fi
done

# Wait for all background jobs to finish
wait

