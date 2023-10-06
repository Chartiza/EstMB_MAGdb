#!/bin/bash
#SBATCH -J getCont2
#SBATCH --partition=amd
#SBATCH -t 190:00:00
#SBATCH --error=contig_err2
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=48G
#SBATCH --mail-user=<pantiukh@gmail.com>
#SBATCH --mail-type=BEGIN,END,FAIL

module load broadwell/megahit/1.2.9
PWD=$(pwd)

while read FQ; do

  NAMEs=`echo "$FQ" | cut -d'/' -f16`
  echo $NAMEs

  megahit -1 $FQ.fq1.gz -2 $FQ.fq2.gz -t 24 -o $PWD/Contigs_DB/assembly_$NAMEs
  rm -r $PWD/Contigs_DB/assembly_$NAMEs/intermediate_contigs

done <smpls.csv

module purge
