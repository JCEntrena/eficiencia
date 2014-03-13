#!/bin/bash
i=10

[[ $# -lt 2 ]] && echo "Sintaxis: $0 <nombre_programa>" && exit -1
touch $1.dat

while [[ $i -lt 10000 ]]; do
    echo -n "$i | "
    echo -n "$i " >> $1.dat
    ./$1 $i >> $1.dat
    let i=$i+10
done