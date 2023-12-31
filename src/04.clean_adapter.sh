#!/usr/bin/bash
#DianaOaxaca 300823

#Trim adapters
qiime cutadapt trim-paired --i-demultiplexed-sequences results/01.demux.qza\
 --p-front-f CTCCTACGGGAGGCAGCAG --p-front-r CTTGTGCGGGCCCCCGTCAATTC\
 --o-trimmed-sequences results/02.demux_clean_adapter.qza

#Get visualization file
qiime demux summarize --i-data results/02.demux_clean_adapter.qza --o-visualization results/02.demux_clean_adapter.qzv
