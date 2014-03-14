#!/bin/bash

# Variables de ejecución
SCRIPT=plot
# Límite e incremento de tamaño.
MAP="burbuja 10000 100
fibonacci 50 1
floyd 1000 5
hanoi 35 1
heapsort 10000 100
insercion 10000 100
mergesort 10000 100
quicksort 10000 100
seleccion 10000 100"
N_ITER=5

function genplot() {
    echo 'set xlabel "Talla del problema(n)"
        set ylabel "Tiempo(s)"
        set terminal jpeg size 800,480
        set output basename.".jpg"
        plot basename.".dat" title "Eficiencia " .basename with linespoints' > $SCRIPT
    gnuplot -e "basename='$1'" $SCRIPT
    rm $SCRIPT
}

function gendata() {
    lim=`echo $MAP | grep "$1 [[:digit:]]* [[:digit:]]*"| cut -f2 -d" "`
    inc=`echo $MAP | grep "$1 [[:digit:]]* [[:digit:]]*" | cut -f3 -d" "`
    ini=`[[ $inc -eq 1 ]] && echo 1 || echo 10`
    
    echo -n "" > $1.dat

    for (( i = $ini; i < $lim; i+=$inc )); 
    do
        echo -n "$i " >> $1.dat
        sum=0
        
        for k in `seq 0 $N_ITER`
        do
            exc=`./$1 $i`
            sum=`echo "$sum+${exc/e/*10^}" | bc -l`
        done
        
        echo `echo $sum/$N_ITER | bc -l` >> $1.dat
    done
}

[[ $2 -eq 1 ]] && gendata $1

genplot $1