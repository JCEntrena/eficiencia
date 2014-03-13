#!/bin/bash

# Variables de ejecución
SCRIPT=plot
SOURCES="burbuja fibonacci floyd hanoi heapsort insercion mergesort quicksort seleccion"

printf  'set xlabel "Talla del problema(n)"
        set ylabel "Tiempo(s)"
        set terminal jpeg size 800,480
        set output basename.".jpg"
        plot basename.".dat" title "Eficiencia " .basename with linespoints' > $SCRIPT
        
for i in $SOURCES
do
    echo -n "" > $i.dat
    j=10
    
    [[ -f $i ]] && g++ ./$i.cpp -o $i
    
    while [[ $j -lt 1000 ]]; do
        echo -n "$j " >> $i.dat
        ./$i $j >> $i.dat
        let j=$j+10
    done
    
    gnuplot -e "basename='$i'" $SCRIPT
    
done

rm -r $SCRIPT