#!/usr/bin/bash
#DianaOaxaca 
#Get phylogeny


echo " Infering phylogenetic tree"

qiime phylogeny align-to-tree-mafft-fasttree --i-sequences results/05.rep-seqs_v3-filter_chloro.qza \
--o-alignment results/08.aligned-rep-seqs.qza --o-masked-alignment results/08.masked-aligned-rep-seqs.qza \
--o-tree results/08.unrooted-tree.qza --o-rooted-tree results/08.rooted-tree.qza --verbose 

echo " Finish phylogeny inference"

