#!/bin/bash

freq=$(awk -F ',' '{print $3}' output.csv | sort -nr | head -n 1)
output_file="defective.csv"

awk -F ',' -v freq="$freq" '
    NR > 1 {
        if ($3 < freq)
            print $2 >> "'"$output_file"'";
    }
' output.csv