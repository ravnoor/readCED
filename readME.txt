Updated: August 11th 2014
1. Program reading replicates of 1000 instead of the whole continuous data - Fixed!

August 9th 2014
1. Use readced.m to read all the CED files.
2. Code uploaded to Github (https://github.com/ravnoor/readCED)

August 7th 2014
1. Use readced.m to read the files 04_01 to 04_11

2. Use readced_olf.m to read the files 04_12 to 04_26. There is an additional field (MarkerSecs) for the marker to indicate the onset of water/toluene presentation.

The program outputs the filename with the *.mat extension in the same folder as the program files. Input files need to be in the readCED folder.

Usage:
readced('filename.smr')

Output:
filename.mat

