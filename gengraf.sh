#!/bin/bash

# Variables de ejecución
SCRIPT=plot
#SOURCES="burbuja fibonacci floyd hanoi heapsort insercion mergesort quicksort seleccion"
SOURCES=`ls *.cpp | rev | cut -f2 -d. | rev`

printf  'set xlabel "Talla del problema(n)"
        set ylabel "Tiempo(s)"
        set terminal jpeg size 800,480
        set output basename.".jpg"
        plot basename.".dat" title "Eficiencia " .basename with linespoints' > $SCRIPT
        
for i in $SOURCES
do
    echo -n "" > $i.dat
    
    g++ ./$i.cpp -o $i # Recompila siempre para utilizar la última versión de los .cpp
    
    echo "Ejecutando $i"

    for (( j = 10; j < 1000; j+=50 )); do
        echo -n "$j " >> $i.dat
        ./$i $j >> $i.dat
    done
    
    gnuplot -e "basename='$i'" $SCRIPT
    
done

rm -r $SCRIPT