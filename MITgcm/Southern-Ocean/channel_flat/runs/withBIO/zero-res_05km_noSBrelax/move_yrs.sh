#!/bin/bash
mkdir cooling_temp_yr16

for i in {777744..829584..144}
    do
        mv ./*0000"$i".* cooling_temp_yr16
    done

