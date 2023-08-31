#!/usr/bin/bash
#Diana Oaxaca 300823

#Denoising versions

echo "Run denoising version 1 281|277"
qiime dada2 denoise-paired --i-demultiplexed-seqs results/02.demux_clean_adapter.qza\
 --p-trunc-len-f 280 --p-trunc-len-r 218\
 --o-representative-sequences results/03.rep-seqs_v1.qza --o-table results/03.feature-table_v1.qza\
 --o-denoising-stats results/03.denoising-stats_v1.qza --p-n-threads 32

echo "Run denoising version 2 0|277"
qiime dada2 denoise-paired --i-demultiplexed-seqs results/02.demux_clean_adapter.qza\
 --p-trunc-len-f 0 --p-trunc-len-r 277\
 --o-representative-sequences results/03.rep-seqs_v2.qza --o-table results/03.feature-table_v2.qza\
 --o-denoising-stats results/03.denoising-stats_v2.qza --p-n-threads 32

echo "Run denoising version 3 0|0 "
qiime dada2 denoise-paired --i-demultiplexed-seqs results/02.demux_clean_adapter.qza\
 --p-trunc-len-f 0 --p-trunc-len-r 0 \
 --o-representative-sequences results/03.rep-seqs_v3.qza --o-table results/03.feature-table_v3.qza\
 --o-denoising-stats results/03.denoising-stats_v3.qza --p-n-threads 32


