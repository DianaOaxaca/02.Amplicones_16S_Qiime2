#!/usr/bin/bash
#DianaOaxaca 290823
#Export artefacts to text files


echo "Get classification with sklearn"

qiime feature-classifier classify-sklearn --i-classifier data/silva-138-99-515-806-nb-classifier.qza \
--i-reads results/03.rep-seqs_v3.qza  --o-classification results/04.taxonomy_sklearn_assign.qza


echo "Get visual artefact"

qiime metadata tabulate --m-input-file results/04.taxonomy_sklearn_assign.qza --o-visualization results/04.taxonomy_sklearn_assign.qzv


echo "Get barplot"

qiime taxa barplot --i-table results/03.feature-table_v3.qza  --i-taxonomy results/04.taxonomy_sklearn_assign.qza \
 --m-metadata-file data/metadata.tsv --o-visualization results/04.taxonomy_sklearn_barplot.qzv

echo "Done taxonomy sklearn classification in denoising v4 test" 
