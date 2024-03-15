output_file="output.csv"
echo "date,node,count" > "$output_file"
for zipfile in *.zip; do
    csv_files=$(unzip -l "$zipfile" | grep '\.csv$' | awk '{print $NF}')
    echo $csv_files
    for csv_file in $csv_files; do
        unzip -p "$zipfile" "$csv_file" > temp_data.csv
        date=$(awk -F ',' 'NR == 2 {print $1}' temp_data.csv)
        date=$(date -d "$date" +"%Y/%m/%d")
        awk -F ',' -v date="$date" '
            NR > 1 {
                count[$3]++;
            }
            END {
                for (settlement in count) {
                    print date "," settlement "," count[settlement] >> "'"$output_file"'";
                }
            }
        ' temp_data.csv
        rm temp_data.csv
    done
done
echo "done"
