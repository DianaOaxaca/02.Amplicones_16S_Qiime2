#!/usr/bin/bash
#DianaOaxaca 

#Filter and export tables

echo " Filter Chloroplast in the feature table"

qiime taxa filter-table --i-table results/03.feature-table_v3.qza --i-taxonomy results/04.taxonomy_sklearn_assign.qza \
 --p-exclude Chloroplast --o-filtered-table results/05.feature-table_v3-filter_chloro.qza

echo "  Filter Chloroplast in the sequences"

qiime feature-table filter-seqs --i-data results/03.rep-seqs_v3.qza --i-table results/05.feature-table_v3-filter_chloro.qza \
 --o-filtered-data results/05.rep-seqs_v3-filter_chloro.qza


echo "  Get collapse by taxa the filter table"

qiime taxa collapse --i-table results/05.feature-table_v3-filter_chloro.qza --i-taxonomy results/04.taxonomy_sklearn_assign.qza \
 --p-level 7 --o-collapsed-table results/06.filter_table_collapse_sp.qza

echo " Export tables"

qiime tools export --input-path results/05.rep-seqs_v3-filter_chloro.qza --output-path results/07.filter-rep-seqs_exported

qiime tools export --input-path results/06.filter_table_collapse_sp.qza --output-path results/07.filter-feature-table_exported

qiime tools export --input-path results/04.taxonomy_sklearn_assign.qza --output-path results/07.taxonomy_exported

#Opciones extra por si el postprocesamiento lo hacemos con librerias que no usen biom o qza
#echo " Add taxonomy to biom table"

#biom add-metadata -i results/07.filter-feature-table_exported/feature-table.biom -o results/07.filter-feature-table_exported/feature-table_with_tax.biom \
#--observation-metadata-fp results/07.taxonomy_exported/taxonomy.tsv

#echo " Convert biom to tsv"

#biom convert -i results/07.filter-feature-table_exported/feature-table_with_tax.biom \
#-o results/07.filter-feature-table_exported/feature-table_with_tax.txt --to-tsv --header-key taxonomy


echo " Finish"
