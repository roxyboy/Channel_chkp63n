#!/bin/bash
rm Eta*.* *Stave*.* S.* *Fluxtave*.* PHL*.* WT*.* UT*.* VT*.* *Veltave*.*

for nPTR in 05 06 07 09 10 11 13 14 15 16 17 18 19 20 21 24 25 26 27 28 29 30 31 
do
    rm PTR*"$nPTR".*.*
    rm PtrFlux"$nPTR".*.*
done
