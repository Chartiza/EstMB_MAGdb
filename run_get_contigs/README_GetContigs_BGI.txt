## Get Contig Scripts
Note: These scripts are designed for getting contigs from reads and are optimized for Illumina clean data.

# Author
Author: Kateryna Pantiukh
Email: pantiukh@gmail.com

# Prerequisites

Before running the binning process, ensure you have the following in place:

Reads: Scripts are fitted the BGI reads structure only. You should have a reads in the location:
'/gpfs/space/GI/GV/EGCUT_data/omics_data/microbiomics/metagenomics/1_raw_data/batch_based/usb1/result_X204SC20042033-Z01_010203part1/X204SC20042033-Z01-F003/01.CleanData/*'
Pathways: All paths (except reads fld) are set as relative, which means you can freely relocate entire folders, but it's essential to maintain the necessary input files for running the scripts.
Files: check presence of needed files in the folder: get_contigs.sh, smpls.csv

# Getting Started

Follow these steps to initiate the binning process:

1. Modify <smpls.csv>: Add the pthways of the selected samples to the <smpls.csv> file.
2. Running the Contigs creating. Execute the following command to initiate the process:

sbatch get_contigs.sh

For any questions or additional details, please feel free to contact the author via email.
