#!/usr/bin/bash
#DianaOaxaca 230823
#Get fastq data of BioProject number: PRJNA556980 

#Download report
#https://www.ebi.ac.uk/ena/browser/view/PRJNA556980

cut -f3,6 data/reporte.txt| cut -d' ' -f4-7 | grep -v 'its' | sed 's/;/\n\t/g' | grep -v 'experiment' > data/reporte_16S.txt

for fq in $(cut -f2 data/reporte_16S.txt); do
	wget $fq data/
done
