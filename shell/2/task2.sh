#!/bin/bash

input_file="output.csv"
output_file="processed_output.csv"

awk -F ',' '
NR > 1 {
    if (!(node in start_date)) {
        start_date[$2] = $1
        end_date[$2] = $1
    } else {
        if (date < start_date[$2]) {
            start_date[$2] = $1
        }
        if (date > end_date[$2]) {
            end_date[$2] = $1
        }
    }
}
END {
    print "node", "start_date", "end_date"
    for (node in start_date) {
        print node "," start_date[node] "," end_date[node]
    }
}' "$input_file" > "$output_file"
echo "output processed"
