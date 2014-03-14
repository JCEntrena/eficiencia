#!/bin/bash

# Variables de ejecución
SCRIPT=plot
# Límite e incremento de tamaño.
MAP="burbuja 5000 100
fibonacci 50 1
floyd 1000 5
hanoi 35 1
heapsort 10000 100
insercion 10000 100
mergesort 10000 100
quicksort 10000 100
seleccion 10000 100"
# Constante del número áureo
aur=`echo "(1+sqrt(5))/2" | bc -l`
# Funciones de ajuste posibles
FUNCS=("a0*(x**3)+a1*(x**2)+a2*x+a3                 a0,a1,a2,a3"
       #"a0*exp(log(a)*x)                            a0"
       #"a0*(($aur)**x)+a1*((1/$aur)**x)+a2*x+a3    a0,a1,a2,a3"
       "a0*x*log(x)+a1*x+a2*log(x)+a3               a0,a1,a2,a3"
       )
# Número de ejecuciones con las que se obtendrá el promedio
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
    lim=`echo $MAP | grep -o "$1 [[:digit:]]* [[:digit:]]*"| cut -f2 -d" "`
    inc=`echo $MAP | grep -o "$1 [[:digit:]]* [[:digit:]]*" | cut -f3 -d" "`
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

     
function bondadajuste() {
    echo "f(x)=$2; fit f(x) '$1.dat' via $3" | gnuplot 2> $1_fit
    result=`cat $1_fit | grep "rms" | grep -o "[[:digit:]]*\.[[:digit:]]*"`
    # echo "$2; $result"; sleep 1
}

function plotajuste() {
    echo "set xlabel 'Talla del problema(n)'
        set ylabel 'Tiempo(s)'
        set terminal jpeg size 800,480
        set output '$1_fit.jpg'
        f(x)=$2
        fit f(x) '$1.dat' via $3
        plot '$1.dat',f(x) title 'Curva ajustada' with linespoints" > $SCRIPT
    gnuplot $SCRIPT 2> $1_fit
    rm $SCRIPT
}

function extrae_f(){
    func=`echo ${FUNCS[$1]} | cut -f1 -d " "`
    coefs=`echo ${FUNCS[$1]}| cut -f2 -d " "`
}    

function genajuste() {
    extrae_f 0
    bondadajuste $1 ${func} ${coefs}
    mejor=$result
    chosen=0
    
    for i in `seq 1 $((${#FUNCS[*]}-1))`
    do
        extrae_f $i
        bondadajuste $1 ${func} ${coefs}
         
        if [[ `echo "($result < $mejor)" | bc -l` -eq 1 ]]
        then
            
            mejor=$result
            chosen=0
        fi
    done
    
    plotajuste $1 $(echo ${FUNCS[$chosen]} | cut -f1 -d " ") $(echo ${FUNCS[$chosen]} | cut -f2 -d " ")

}


[[ $2 -eq 0 ]] && genplot $1

[[ $2 -eq 1 ]] && gendata $1

[[ $2 -eq 2 ]] && genajuste $1