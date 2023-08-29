#!/usr/bin/bash
#DianaOaxaca 230823

cut -f3,6 data/reporte.txt| cut -d' ' -f4-7 | grep -v 'its' | sed 's/ rep /_/g' | tr ';' '\t' | \
sed  's/ftp.*\///' | sed 's/_2\..*//g' | sed 's/experiment_title/sample-id/' | \
awk -F'\t' '{print $1"\t"$2"\t"$1}' | sed 's/_?*.$//' | sed 's/sample-id$/source/' > data/metadata.tsv
