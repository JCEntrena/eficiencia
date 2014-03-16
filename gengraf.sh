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
FUNCS=("a0                                          a0"
       "a0*x+a1                                     a0,a1"
       "a0*(x**2)+a1*x+a0                           a0,a1,a2"      
       "a0*(x**3)+a1*(x**2)+a2*x+a3                 a0,a1,a2,a3"
       "a0*x*log(x)+a1*x+a2*log(x)+a3               a0,a1,a2,a3"
       #"a0*exp(log(a)*x)                            a0"
       #"a0*(($aur)**x)+a1*((1/$aur)**x)+a2*x+a3    a0,a1,a2,a3"
       )
EXCL="fibonacci hanoi"
# Número de ejecuciones con las que se obtendrá el promedio
N_ITER=5



# param $1 "nombre del algoritmo (mergesort, heapsort,...)"
#
# Función que permite hacer un plot de un archivo $1.dat ya generado
#
function genplot() {
    echo 'set xlabel "Talla del problema(n)"
        set ylabel "Tiempo(s)"
        set terminal jpeg size 800,480
        set output basename.".jpg"
        plot basename.".dat" title "Eficiencia " .basename with linespoints' > $SCRIPT
    gnuplot -e "basename='$1'" $SCRIPT
    rm $SCRIPT
}


# param $1 "nombre del algoritmo (mergesort, heapsort,...)"
#
# Genera un archivo .dat donde la primera columna correponde a tallas del problema,
# y la segunda a tiempo que necesita el algoritmo para resolver un problema de esa
# talla
#
function gendata() {
    # Se extraen los valores de talla máxima del problema e incremento del número
    # de datos que se introducirán al algoritmo, así como la talla inicial
    lim=`echo $MAP | grep -o "$1 [[:digit:]]* [[:digit:]]*"| cut -f2 -d" "`
    inc=`echo $MAP | grep -o "$1 [[:digit:]]* [[:digit:]]*" | cut -f3 -d" "`
    ini=`[[ $inc -eq 1 ]] && echo 1 || echo 10`
    
    echo -n "" > $1.dat
    
    for i in `seq $ini $inc $lim`; do #(( i = $ini; i < $lim; i += $inc )); do
        echo -n "$i " >> $1.dat
        sum=0
        
        # Se obtiene un promedio en N_ITER ejecuciones para la talla dada
        for k in `seq 0 $N_ITER`
        do
            exc=`bin/$1 $i`
            sum=`echo "$sum+${exc/e/*10^}" | bc -l`
        done
        
        echo `echo $sum/$N_ITER | bc -l` >> $1.dat
    done
}


# param $1 "nombre del algoritmo (mergesort, heapsort,...)"
# param $2 "función de ajuste"
# param $3 "coeficientes de la función de ajuste correspondiente"
# return result "Residuos del ajuste"
#
function bondadajuste() {
    echo "f(x)=$2; fit f(x) '$1.dat' via $3" | gnuplot 2> tmp
    result=`cat tmp | grep "rms" | grep -o "[[:digit:]]\+.*$"`
    echo -e "Ajuste: f(x)=$2\n" >> $1_fit
    cat tmp >> $1_fit
    rm -f tmp
    echo -e "\n\n##########################################################################\n\n" >> $1_fit
}


# param $1 "nombre del algoritmo (mergesort, heapsort,...)"
# param $2 "función de ajuste"
# param $3 "coeficientes de la función de ajuste correspondiente"
#
# Hace un plot del .dat junto a la función que más se le ajusta de
# entre las disponibles en FUNCS
#
function plotajuste() {
    echo "set xlabel 'Talla del problema(n)'
        set ylabel 'Tiempo(s)'
        set terminal jpeg size 800,480
        set output '$1_fit.jpg'
        f(x)=$2
        fit f(x) '$1.dat' via $3
        plot '$1.dat',f(x) title 'Curva ajustada' with linespoints" > $SCRIPT
    echo "****   Función de mejor ajuste: $2   *****" >> $1_fit
    gnuplot $SCRIPT 2> /dev/null
    rm -f $SCRIPT
}


# param $1 "índice(válido) de FUNCS"
# return func "función de ajuste i-ésima de FUNCS"
# return coefs "coeficientes de ajuste de la función i-ésima"
#
function extrae_f(){
    func=`echo ${FUNCS[$1]} | cut -f1 -d " "`
    coefs=`echo ${FUNCS[$1]}| cut -f2 -d " "`
}    


# param $1 "nombre del algoritmo (mergesort, heapsort,...)"
# 
# Genera el plot del mejor ajuste posible de entre los de FUNCS
# para $1.dat
#
function genajuste() {
    [[ `echo $EXCL | grep $1` ]] && exit 0
    
    echo -n "" > $1_fit
    # Suponemos FUNCS no vacío
    extrae_f 0
    bondadajuste $1 ${func} ${coefs}
    mejor=$result
    chosen=0
    
    # Para cada ajuste en FUNCS
    # Calcula sus residuos
    # Si es mejor ajuste que el mejor hasta el momento
    #       Actualizar mejor ajuste
    for i in `seq 1 $((${#FUNCS[*]}-1))`
    do
        extrae_f $i
        bondadajuste $1 ${func} ${coefs}
        
        
        if [[ `echo "(${result/e/*10^} < $mejor)" | bc -l` -eq 1 ]]
        then
            
            mejor=${result/e/*10^}
            chosen=$i
        fi
    done
    
    plotajuste $1 $(echo ${FUNCS[$chosen]} | cut -f1 -d " ") $(echo ${FUNCS[$chosen]} | cut -f2 -d " ")

}

# Extraemos el nombre del source a partir del path
PN=${1##*/}

# Si el argumento del script es 0, hacemos un plot de datos
# Si es 1, generamos el .dat correspondiente al archivo pasado
# Si es 2, generamos un plot del ajuste al .dat del archivo pasado

[[ $2 -eq 0 ]] && genplot $PN && exit 0

[[ $2 -eq 1 ]] && gendata $PN && exit 0

[[ $2 -eq 2 ]] && genajuste $PN && exit 0

exit 1
