#!/bin/bash
#SBATCH -J remove_host
#SBATCH --partition=amd
#SBATCH -t 39:00:00
#SBATCH --error=remove_host_err1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=128G
#SBATCH --mail-user=<pantiukh@gmail.com>
#SBATCH --mail-type=BEGIN,END,FAIL

module load bowtie2/2.4.1
module load samtools/1.3.1

# Read values from the command-line argument
R1=$1
R2=$2
bNAME=$3

# define paths to genome reference & output folders
PWD=$(pwd)
mkdir -p $PWD/temp
mkdir -p $PWD/host_removed_reads
ref='/gpfs/space/home/pantiukh/data_references/GRCh38_noalt_as_human'

# Start programs
echo 'Run bowtie2 for '$bNAME
echo 'start time is '$(date)

#complex solution that gives better control over the rejected reads by using SAM-flags
bowtie2 -p 16 -x $ref/GRCh38_noalt_as -1 $R1 -2 $R2 -S $PWD/temp/$bNAME'_mapped_and_unmapped.sam'
samtools view -bS $PWD/temp/$bNAME'_mapped_and_unmapped.sam' > $PWD/temp/$bNAME'_mapped_and_unmapped.bam'
  
#filter required unmapped reads
samtools view -b -f 12 -F 256 $PWD/temp/$bNAME'_mapped_and_unmapped.bam' > $PWD/temp/$bNAME'_bothReadsUnmapped.bam'
samtools view -b -F 12 -F 256 $PWD/temp/$bNAME'_mapped_and_unmapped.bam' > $PWD/temp/$bNAME'_bothReadsMapped.bam'
  
#split paired-end reads into separated fastq files .._R1 .._R2
samtools sort -n -m 5G -@ 2 $PWD/temp/$bNAME'_bothReadsUnmapped.bam' -o $PWD/temp/$bNAME'_bothReadsUnmapped_sorted.bam'
samtools sort -n -m 5G -@ 2 $PWD/temp/$bNAME'_bothReadsMapped.bam' -o $PWD/temp/$bNAME'_bothReadsMapped_sorted.bam'

samtools fastq $PWD/temp/$bNAME'_bothReadsUnmapped_sorted.bam' \
 -1 $PWD/host_removed_reads/$bNAME'_host_removed_R1.fastq' -2 $PWD/host_removed_reads/$bNAME'_host_removed_R2.fastq' -0 /dev/null -s /dev/null -n

gzip $PWD/host_removed_reads/$bNAME'_host_removed_R1.fastq'
gzip $PWD/host_removed_reads/$bNAME'_host_removed_R2.fastq'

cp $PWD/host_removed_reads/$bNAME'_host_removed_R1.fastq.gz' $Rfld'/'
cp $PWD/host_removed_reads/$bNAME'_host_removed_R2.fastq.gz' $Rfld'/'

#samtools fastq $PWD/$bNAME'_bothReadsMapped_sorted.bam' \
  #-1 $PWD/only_host_reads/$bNAME'_host_only_R1.fastq.gz' -2 $PWD/only_host_reads/$bNAME'_host_only_R2.fastq.gz' -0 /dev/null -s /dev/null -n

rm $PWD/temp/$bNAME*.bam
rm $PWD/temp/$bNAME*.sam

echo 'end time is '$(date)
module purge
