
#!/bin/bash
#===================================================================
#RNA-Seq adapter trimming using fastp
#Author: Shweta Yadav
#Date:28 Feb 2026
#====================================================================
#Load configuration file
source config.sh
#===========User adjustable parameters===============================
#This may be adjusted based on the sequence quality
TRIM_FRONT_1=15
TRIM_FRONT_2=15
qual=30
minlen=80

#Create output directory
mkdir -p "$fastqc"
mkdir -p "$trimmed_reads"
mkdir -p "$fastqc_post_trimming"
LOG_FILE="$trimmed_reads/trimming_log.txt"

#====================================================================
#fastqc before trimming
#====================================================================
for file in "$fastq_files"/*_1.fastq.gz
do
    sample_name=$(basename "$file" _1.fastq.gz)
    input_file1="$file"
    input_file2="$fastq_files/${sample_name}_2.fastq.gz"
    
    echo "Processing $sample_name"
    echo "$input_file1"
    echo "$input_file2"
    
    fastqc -t "$threads" -o "$fastqc" "$input_file1" "$input_file2"
done   
echo "FastQC done for raw data"

#======================================================================
#Adapter trimming using fastp
#======================================================================
for file in "$fastq_files"/*_1.fastq.gz
do
    sample_name=$(basename "$file" _1.fastq.gz)
    input_file1="$file"
    input_file2="$fastq_files/${sample_name}_2.fastq.gz"
    output_r1="$trimmed_reads/${sample_name}_1.trimmed.fastq.gz"
    output_r2="$trimmed_reads/${sample_name}_2.trimmed.fastq.gz"
    
    echo "Processing $sample_name"
    echo "$input_file1"
    echo "$input_file2"
    
fastp \
   -i "$input_file1" \
   -I "$input_file2" \
   -o "$output_r1" \
   -O "$output_r2" \
   
--detect_adapter_for_pe \
--trim_front1 $TRIM_FRONT_1 \
--trim_front2 $TRIM_FRONT_2 \
--qualified_quality_phred $qual \
--length_required $minlen \
-w "$threads" \
>> "$LOG_FILE" 2>&1 
echo "Trimming done for $sample_name"
done

#===================================================================
#fastqc post trimming
#===================================================================

for file in "$trimmed_reads"/*_1.trimmed.fastq.gz
do
    sample_name=$(basename "$file" _1.trimmed.fastq.gz)
    input_file1="$file"
    input_file2="$trimmed_reads/${sample_name}_2.trimmed.fastq.gz"
    
    echo "Processing $sample_name"
    echo "$input_file1"
    echo "$input_file2"
    
fastqc -t "$threads" -o "$fastqc_post_trimming" "$input_file1" "$input_file2"

echo "Fastqc post trimming is done"
done
