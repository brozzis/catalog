#!/bin/sh

for i in $1/*.TIF 
do
    convert $i `basename $i .TIF`.jpg 
done