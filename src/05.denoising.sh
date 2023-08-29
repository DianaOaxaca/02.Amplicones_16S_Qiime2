#!/usr/bin/bash
#Diana Oaxaca 290823

#Denoising versions


#echo "Run denoising version 1 285|147"
#qiime dada2 denoise-paired --i-demultiplexed-seqs results/02.demux_clean_adapter.qza\
# --p-trunc-len-f 285 --p-trunc-len-r 147\
# --o-representative-sequences results/03.rep-seqs_v1.qza --o-table results/03.feature-table_v1.qza\
# --o-denoising-stats results/03.denoising-stats_v1.qza --p-n-threads 8

#echo "Run denoising version 2 0|0"
#qiime dada2 denoise-paired --i-demultiplexed-seqs results/02.demux_clean_adapter.qza\
# --p-trunc-len-f 0 --p-trunc-len-r 0\
# --o-representative-sequences results/03.rep-seqs_v2.qza --o-table results/03.feature-table_v2.qza\
# --o-denoising-stats results/03.denoising-stats_v2.qza --p-n-threads 8

#echo "Run denoising version 3 0|0 pmax-ee-r 5.0"
#qiime dada2 denoise-paired --i-demultiplexed-seqs results/02.demux_clean_adapter.qza\
# --p-trunc-len-f 0 --p-trunc-len-r 0 --p-max-ee-r 5.0\
# --o-representative-sequences results/03.rep-seqs_v3.qza --o-table results/03.feature-table_v3.qza\
# --o-denoising-stats results/03.denoising-stats_v3.qza --p-n-threads 8
