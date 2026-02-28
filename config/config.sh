#!/bin/bash
#===================================================
#Configuration file for RNA-Seq pipeline
#===================================================
#The path for raw data, this will be the input
fastq_files="/path/to/the/directory/raw_data"
#fastqc of data before trimming
fastqc="/path/to/the/directory/fastqc_reports"
# the path where the trimmed file will be saved 
trimmed_reads="/path/to/the/directory/Trimmed_reads"
# the path where the fastqc report after trimming will be saved
fastqc_post="/path/to/the/directory/fastqc_post_trimming"
#no of threads, you can adjust based on the available CPU cores
threads=4
