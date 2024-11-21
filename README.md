# Protein Analyzer

This is a very simple script to create a batch file to analyze multiple peptide sequences in parallel with EMBOSS. 

Just save the `.FASTA` files in a folder named fastaseq and execute the script with perl:

```
perl protein_analyzer.pl
```

Then you must call the BATCH file generated (emboss.bat) to execute the EMBOSS commands.

The documentation is attached as a `.bat` example file to analyze the sequence of protein PDL-1, also attached as Q9NZQ7.fasta. You can see the analysis results in the DATA folder.

You can also see the HMMER Analysis result in `HMMER_DATA` folder.
