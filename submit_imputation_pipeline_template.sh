#!/bin/bash

#SBATCH --time=72:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=6G
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --job-name="ImputeGenotypes"

# These are needed modules in UT HPC to get Singularity and Nextflow running.
# Replace with appropriate ones for your HPC.
module load java-1.8.0_40
module load singularity/3.5.3
module load squashfs/4.4

# Define paths
nextflow_path=../../tools # folder where Nextflow executable is, can be kept as is.
reference_path=../hg38 # folder where you unpacked the reference files, can be kept as is.

input_path=[full path to your input genotype files, without extensions]
cohort_name=[name of your cohort]
gte=[full path to your genotype-to-expression file]
output_path=../output/ # Output path, can be kept as is.

# Command
NXF_VER=21.10.6 ${nextflow_path}/nextflow run eQTLGenImpute.nf \
--bfile ${input_path} \
--target_ref ${reference_path}/ref_genome_QC/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
--ref_panel_hg38 ${reference_path}/ref_panel_QC/30x-GRCh38_NoSamplesSorted \
--eagle_genetic_map ${reference_path}/phasing/genetic_map/genetic_map_hg38_withX.txt.gz \
--eagle_phasing_reference ${reference_path}/phasing/phasing_reference/ \
--minimac_imputation_reference ${reference_path}/imputation/ \
--cohort_name ${cohort_name} \
--gte ${gte} \
--outdir ${output_path}  \
-profile slurm,singularity \
-resume