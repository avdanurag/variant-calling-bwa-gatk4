# Quality Filtration, Mapping, and Variant Calling Pipeline

This repository contains a set of shell scripts for performing quality filtration of Illumina raw reads, mapping with BWA, and variant calling with GATK HaplotypeCaller. The pipeline includes the following scripts:

## Scripts

### fastp.sh

Quality filtration of Illumina raw reads using the `fastp` tool.

Usage:
```bash
bash fastp.sh <input_dir> <output_dir>

```

### bwa.sh

Mapping of quality-filtered reads to a reference genome using BWA.

Usage:

```bash
bash bwa.sh <reference_dir> <input_dir> <output_dir>

```
### sortSAM.sh
Sorting and indexing SAM files using GATK's SortSam.

Usage:

```bash
bash sortSAM.sh <input_dir> <output_dir>
```

### dedupBAM.sh
Deduplication of sorted BAM files using GATK's MarkDuplicates.

Usage:
```bash
bash dedupBAM.sh <input_dir> <output_dir>
```

haplotypecaller.sh
Variant calling using GATK HaplotypeCaller and generating gVCF files.

Usage:
```bash
bash haplotypecaller.sh <reference_genome> <input_dir> <output_dir> <tmp_dir> <num_runs>
```
## Usage
- Clone this repository to your local machine.

- Ensure you have the necessary dependencies installed (e.g., fastp, BWA, GATK).

- Create a directory structure for your data, reference, and output.

- Run each script with the required arguments according to their respective usage instructions.

## Output
The output of each script includes quality-filtered reads, sorted and indexed BAM files, deduplicated BAM files, and gVCF files for variant calling.


