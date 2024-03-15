#!/bin/bash

output_file="output.csv"

echo "date,node,count" > "$output_file"

mkdir temp
for folder in {01..31}; do
    cd "$folder" || exit

    for zipfile in *.zip; do
        cp $zipfile ../temp/
        cd ../temp
        csv_files=$(unzip -l "$zipfile" | grep '\.csv$' | awk '{print $NF}')
        for csv_file in $csv_files; do
            unzip -p "$zipfile" "$csv_file" > "$csv_file".csv
            date=$(awk -F ',' 'NR == 2 {print $1}' "$csv_file".csv)
            date=$(date -d "$date" +"%Y/%m/%d")
            awk -F ',' -v date="$date" '
            NR > 1 {
                count[$3]++;
            }
            END {
                for (settlement in count) {
                    print date "," settlement "," count[settlement] >> "'../"$output_file"'";
                }
            }
        ' "$csv_file".csv
        done
    done
    cd ..
done
rm -r temp

echo "output created"