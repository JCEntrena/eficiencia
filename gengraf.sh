#!/bin/bash

# Variables de ejecución
SCRIPT=plot
SOURCES=`ls *.cpp | rev | cut -f2 -d. | rev`
LIMITS=(10000 50 1000 35 10000 10000 10000 10000 10000)
INC=(100 1 5 1 100 100 100 100 100)
N_ITER=5

printf  'set xlabel "Talla del problema(n)"
        set ylabel "Tiempo(s)"
        set terminal jpeg size 800,480
        set output basename.".jpg"
        plot basename.".dat" title "Eficiencia " .basename with linespoints' > $SCRIPT
        
for i in `seq 0 $((${#SOURCES[*]}-1))`
do
    src=${SOURCES[$i]}
    inc=${INC[$i]}
 
    echo -n "" > $src.dat
    [[ $inc -eq 1 ]] && j=1 || j=10
    
    g++ ./$src.cpp -o $src

    while [[ $j -lt ${LIMITS[$i]} ]]; 
    do
        echo -n "$j " >> $src.dat
        sum=0
        
        for k in `seq 0 $N_ITER`
        do
            exc=`./$src $j`
            sum=`echo "$sum+${exc/e/*10^}" | bc -l`
        done
        
        echo `echo $sum/$N_ITER |bc -l` >> $src.dat
        let j=$j+$inc
    done
    
    echo -n "$src generado..."
    
    gnuplot -e "basename='$src'" $SCRIPT
    
done

rm -r $SCRIPT