#!/usr/bin/perl 

my $seq = fastaseq;

#LOCALIZA LOS FICHEROS FASTA
############################

#abre el directorio introducido donde se encuentran las secuencias creando un Filehandle.
opendir(DIR, $seq) or die "$!\n You have to create a fastaseq directory with .fasta sequences";

#lee el contenido del directorio que contiene
my @files = grep {".fasta"} readdir(DIR);

#cierra el Filehandle.
closedir(DIR);

#CREA EL ARCHIVO BATCH
######################

#crea el batch donde irán las órdenes específicas para el análisis de secuencias con EMBOSS:
open (OUTPUT, '>emboss.bat');

#ANALISIS PROTEINA
##################

#@files contiene los nombres de todos los ficheros y directorios del directorio seleccionado. Tenemos que mirar uno a uno.
foreach my $file(@files){
   next unless (-f "$seq/$file");
   
   #infoseq to get information about the sequence
   print OUTPUT "infoseq $file > $file.infoseq\n";
    
   #PROTEIN COMPOSITION
   ####################
   #backtranambig to back-translate a protein sequence to ambiguous nucleotide sequence
   print OUTPUT "backtranambig $file -outfile ambigous_nucleotide_$file\n";
   #backtranseq to back-translate a protein sequence to a nucleotide sequence
   print OUTPUT "backtranseq $file -outfile nucleotide_$file\n";
   #compseq to calculate the composition of unique words in sequences
   print OUTPUT "compseq $file -word 1 -auto\n";
   #pepdigest to report on protein proteolytic enzyme or reagent cleavage sites
   print OUTPUT "pepdigest $file -menu 1 -outfile trypsin_$file -auto\n";
   print OUTPUT "pepdigest $file -menu 2 -outfile LysC_$file -auto\n";
   print OUTPUT "pepdigest $file -menu 3 -outfile ArgC_$file -auto\n";
   print OUTPUT "pepdigest $file -menu 4 -outfile AspN_$file -auto\n";
   print OUTPUT "pepdigest $file -menu 5 -outfile V8bicarb_$file -auto\n";
   print OUTPUT "pepdigest $file -menu 6 -outfile V8phosph_$file -auto\n";
   print OUTPUT "pepdigest $file -menu 7 -outfile Chymotryps_$file -auto\n";
   print OUTPUT "pepdigest $file -menu 8 -outfile CNBr_$file -auto\n";
   #wordcount to count and extract unique words in molecular sequence
   print OUTPUT "wordcount $file -wordsize 1 -auto\n";   

   #PROTEIN PROPERTIES 
   ###################
   #pepinfo to produce information on amino acid properties (size, polarity, aromaticity, charge etc)
   print OUTPUT "pepinfo $file -outfile prot_report.pepinfo -graph png -auto\n";
   #pepstats to Calculate statistics of protein properties.
   print OUTPUT "pepstats $file -outfile protein_properties.pepstats\n";
   #charge to draw a protein charge plot
   print OUTPUT "charge $file -graph png -auto\n";
   #iep to calculate the isoelectric point of proteins
   print OUTPUT "iep $file -auto\n";
   #hmoment to calculate and plot hydrophobic moment for protein sequence
   print OUTPUT "hmoment $file -auto\n";
   #octanol to draw a WW protein hydropathy plot
   print OUTPUT "octanol $file -graph png -auto\n";
   #pepwindowall to draw a KD protein hydropathy plot
   print OUTPUT "pepwindowall $file -graph png -auto\n";

   #PROTEIN FUNCTIONAL SITES
   #########################
   #tmap to predict transmembrana regions
   print OUTPUT "tmap $file -out tmap.res -graph png -gsubtitle $file\n";
   #sigcleave to report on signal cleavage sites in a protein sequences
   print OUTPUT "sigcleave $file -auto\n";  

   #PROTEIN 2D STRUCTURE
   #####################
   #garnier to predict protein secondary structure using GOR method
   print OUTPUT "garnier $file -auto\n";
   #helixturnhelix to identify nucleic acid-binding motifs in protein sequences
   print OUTPUT "helixturnhelix $file -auto\n";
   #pepcoil to predict coiled coil regions in protein sequences
   print OUTPUT "pepcoil $file -auto\n";
   #pepwheel to draw a helical wheel diagram for a protein sequence
   print OUTPUT "pepwheel $file -graph png\n";

   #PROTEIN MOTIFS 
   ###############
   #antigenic to find antigenic sites in proteins
   print OUTPUT "antigenic $file -rformat gff -auto\n";
   #epestfind to find PEST motifs as potential proteolytic cleavage sites
   print OUTPUT "epestfind $file -graph png -invalid -auto\n";
   
}

print "'Protein Analysis with EMBOSS' batch file created (emboss.bat). You have to call it to run EMBOSS commands\n";









