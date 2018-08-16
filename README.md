# FunChiSq
# Language: R
# Input: CSV (contains samples and quanta)
# Output: CSV (functional dependencies)
# Tested with: PluMA 1.0, Python 2.7

PluMA plugin that calculates dependencies between entities using the FunChiSq (Zhang and Song, 2013) algorithm.

The plugin accepts as input a CSV file containing a set of samples (rows) and entities (columns).  Entry
(i, j) of this CSV file should contain a denoised quantum value for entity j in sample i (this can be produced
by the CKMeans plugin, available from the PluMA plugin pool or at: https://github.com/movingpictures83/CKMeans).

This plugin will then produce a CSV file with entities on both rows and columns, with entry (i, j) the functional
dependence between entity i and entity j.
