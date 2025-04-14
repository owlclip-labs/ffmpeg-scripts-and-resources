#!/bin/bash
# This script processes videos according to a CSV file
# CSV format: input_file,output_file,start_time,end_time
# Usage: ./process_video_list.sh video_list.csv

csv_file="$1"

while IFS=, read -r input output start end; do
    echo "Processing: $input -> $output (from $start to $end)"
    ffmpeg -nostdin -i "$input" -ss "$start" -to "$end" -c copy "$output" -hide_banner -loglevel warning
done < "$csv_file"