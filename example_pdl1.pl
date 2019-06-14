#!/usr/bin/perl

############################
## DOWNLOAD THE SEQUENCES ##
############################

## wget 

######################################################################################################################
## EMBOSS

#######################
## READING SEQUENCES ##
#######################

## Habría que descargar la secuencia de la proteína. Yo la he descargado de UNIPROT. 

## Para poner el archivo en el formato fasta:
seqret Q9NZQ7.fasta -outseq pd1l1_human.fasta

## También se puede descargar la secuencia de la proteína directamente desde la base de datos:
## seqret embl:xlrhodop -outseq xlrhodop.fasta

## Para ver la secuencia en pantalla:
more pd1l1_human.fasta

## EMBOSS can also read sequences from files. For example, if we wanted to reformat the fasta sequence we have downloaded into gcg format, we could say:

## seqret xlrhodop.fasta -outseq gcg::myseq.gcg

#########################
## PROTEIN COMPOSITION ##
#########################

## To calculate the composition of triucleotides in sequence:

compseq Homo_sapiens_CD274_sequence.fa -word 3 -outfile trinucleotide_composition.comp

## To reads one or more sequences and a set of bases or residues to search for. It then calculates the frequency of these bases/residues in a window as it moves along the sequence. The frequency is output to a data file or (optionally) plotted.

freak Homo_sapiens_CD274_sequence.fa -plot -graph png -outfile base_frequency_plot.freak -auto

#########################
## IDENTIFYING THE ORF ##
#########################

## In this section we'll show you some simple EMBOSS applications for translating your cDNA sequence into protein. You should be aware that gene structure prediction is a tough problem, and recognising exon/intron boundaries in genomic sequence is not easy; for now, rather than deal with that aspect of prediction, we'll use the cDNA sequence in our practical. First, we need to identify our open reading frame. 

## GETORF ##
#############

## We can get a rapid visual overview of the distribution of ORFs in the six frames of our sequence using the EMBOSS program plotorf. 

getorf Homo_sapiens_CD274_sequence.fa -opt -outseq pdl1.orf -minsize 20 -auto

##############################
## Translating the sequence ##
##############################

## From the previous exercise you should have found that the region to be translated is from 110 to 1171 in our cDNA sequence. Now we can use transeq	to translate that region and use the translated peptide for some further analyses. 

## SIXPACK ##
#############

## SIXPACK reads a DNA sequence and writes an output file giving out the forward and reverse sense sequences with the three forward and (optiosixpacknally) three reverse translations in a pretty display format. A genetic code may be specified for the translation. There are various options to control the appearance of the output file. It also writes a file of protein sequences corresponding to any open reading frames that are larger than the specified minimum size: the default of 1 base shows all possible open reading frames.

sixpack -sequence Homo_sapiens_CD274_sequence.fa -outseq Homo_sapiens_CD274_sequence_ORF.fa -outfile out_pdl1.sixpack

## TRANSEQ ##
#############

## Translate nucleic acid sequences

transeq Homo_sapiens_CD274_sequence.fa -outseq Homo_sapiens_CD274_sequence.pep

## NEEDLE ##
############

## using needle to compare your translated product with the database sequence.

needle Homo_sapiens_CD274_sequence.pep pd1l1_human.fasta -outfile alignment.needle -auto

#################################
## PROPIEDADES FÍSICO-QUÍMICAS ##
#################################

## To Calculate statistics of protein properties.

pepstats pd1l1_human.fasta -outfile protein_properties.pepstats

## pepinfo ##
#############

## produces information on amino acid properties (size, polarity, aromaticity, charge etc). Hydrophobicity profiles are also available and are useful for locating turns, potential antigenic peptides and transmembrane helices. Various algorithms are employed including the Kyte and Doolittle hydropathy measure - this curve is the average of a residue-specific hydrophobicity index over a window of nine residues. When the line is in the upper half of the frame, it indicates a hydrophobic region, and when it is in the lower half, a hydrophilic region. 

pepinfo pd1l1_human.fasta -outfile prot_report.pepinfo -graph png -auto

## Report on protein proteolytic enzyme or reagent cleavage sites 

## En el menú se indica el reactivo o la enzima que se usa. Habría que hacerlo para todas las posibilidades.

pepdigest pd1l1_human.fasta -outfile enzyme_cleavage_sites.pepdigest -menu 1 -auto

## charge reads a protein sequence and writes a file (or plots a graph) of the mean charge of the amino acids within a window of specified length as the window is moved along the sequence.

charge pd1l1_human.fasta -graph png -plot -outfile protein_charge.charge

## To Calculate and plot hydrophobic moment for protein sequence(s) 

hmoment pd1l1_human.fasta -graph png -plot -outfile hidrophobic.hmoment

## TO Calculate the isoelectric point of proteins 

iep pd1l1_human.fasta -plot -graph png -outfile isoelectric.iep

## To Draw a hydropathy plot for a protein sequence 

pepwindow pd1l1_human.fasta -graph png

####################################
## SECONDARY STRUCTURE PREDICTION ##
####################################

##  The question of how DNA sequence determines specific protein structure has been a constant source of fascination and speculation since the problem was identified. It remains an extremely difficult area; generally referred to as the ``folding problem'', it is one of the major outstanding questions in molecular biology. Many attempts have been made to predict the tertiary structure of a protein from its sequence. These fall into two distinct approaches:

## One approach is to set up a realistic mechanical model of the protein chain and simulate the folding process.
## Other approaches are empirical as they proceed by inference from known tertiary structures. 

## The approach to structure prediction based on mechanical models has the innate (possibly fatal) attraction that, in theory, it requires no prior knowledge of protein tertiary structure. If successful it could be applied uniformly to all sequences. By contrast, all methods based on inference from known structures are inherently limited in their applicability. They will only be appropriate for predicting structures similar to those which were used in the inference process. Fortunately there are often biophysical or biochemical clues that help make this decision and these are often integrated in the methods for structure prediction. 


## garnier ##
#############

## Predict protein secondary structure using GOR method

garnier pd1l1_human.fasta -outfile secondary_structure.garnier

## helixturnhelix ##
####################

## helixturnhelix uses the method of Dodd and Egan to identify helix-turn-helix nucleic acid binding motifs in an input protein sequence. The output is a standard EMBOSS report file describing the location, size and score of any putative motifs.

helixturnhelix pd1l1_human.fasta -outfile nuclec_acid_binding_motifs.hth

## pepcoil ##
#############

pepcoil pd1l1_human.fasta coiled_coil_predicting.pepcoil -auto

## TMAP to Predict transmembrane regions ##
###########################################

## The results from the pepinfo hydropathy plot showed seven highly hydrophobic regions within xlrhodop.pep. Could these be transmembrane domains? We can use the EMBOSS program tmap to investigate this possibility: 

tmap pd1l1_human.fasta -outfile pd1l1_transmembrane_regions.tmap -graph png -auto

## Pattern Matching ##
######################

## NO SE COMO SE HACE

## In a number of cases, the active site of a protein can be recognized by a specific ``fingerprint'' or ``template'', a fairly small set of residues that are unique to a family of proteins. An example is the sequence GXGXXG (where G=glycine and X=any amino acid) which defines a GTP binding site. Searching for a (rather loose) predefined string of characters in a sequence is called Pattern Matching.

## The EMBOSS program patmatmotifs	looks for sequence motifs by searching with a pattern search algorithm through the given protein sequence for the patterns defined in the PROSITE database, compiled by Dr. Amos Bairoch at the University of Geneva. PROSITE is a database of protein families and domains, based on the observation that, while there are a huge number of different proteins, most of them can be grouped, on the basis of similarities in their sequences, into a limited number of families. Proteins or protein domains belonging to a particular family generally share functional attributes and are derived from a common ancestor.

## patmatmotifs 

########################
## SITIOS FUNCIONALES ##
########################

## sigcleave predicts the site of cleavage between a signal sequence and the mature exported protein using the method of von Heijne. It reads one or more protein sequences and writes a standard EMBOSS report with the position, length and score of each predicted signal sequence. Optionally, you may specify the sequence is prokaryotic and this will change the default scoring data file used. The predictive accuracy is estimated to be around 75-80% for both prokaryotic and eukaryotic proteins.

sigcleave pd1l1_human.fasta -outfile cleave.sig -auto

########################################
## MODIFICACIONES POST-TRADUCCIONALES ##
########################################

##########################
## MOTIVOS EN PROTEÍNAS ## 
##########################

## To find antigenic sites in proteins

antigenic pd1l1_human.fasta -outfile antigenic_sites.antigenic -auto

## To Find PEST motifs as potential proteolytic cleavage sites

epestfind -graph png -sequence pd1l1_human.fasta -outfile pest_motifs.epestfind -auto

#############################################################################################
## HMMER

## Single sequence protein queries using phmmer

## The phmmer program is for searching a single sequence query against a sequence database,  much as BLASTP or FASTA would do. phmmer works essentially just like hmmsearch does, except you provide a query sequence instead of a query profile HMM










