#!/bin/bash

# Variables de ejecución
SCRIPT=plot
# Límite e incremento de tamaño.
MAP="burbuja 10000 200
fibonacci 50 1
floyd 1000 5
hanoi 35 1
heapsort 10000 100
insercion 10000 200
mergesort 10000 100
quicksort 10000 100
seleccion 10000 200"
# Constante del número áureo
aur=`echo "(1+sqrt(5))/2" | bc -l`
# Funciones de ajuste posibles
FUNCS=( "a0                                                     a0"
        "a0*x+a1                                                a0,a1"
        "a0*(x**2)+a1*x+a0                                      a0,a1,a2"      
        "a0*(x**3)+a1*(x**2)+a2*x+a3                            a0,a1,a2,a3"
        "a0*x*log(x)+a1*x+a2*log(x)+a3                          a0,a1,a2,a3"
        "a0*(2**x)+a1                                           a0,a1"
        "a0*(($aur)**x)+a1*((1/$aur)**x)+a2*(x**2)+a3*x+a4      a0,a1,a2,a3,a4"
        "a0*exp(a1*x)+a2                                        a0,a1,a2"
        "a0*exp(a2*x)+a2*x+a3                                   a0,a1,a2,a3"
        "a0*exp(a1*x)+a2*(x**2)+a3*x+a4                         a0,a1,a3,a4" 
       )
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
    result=`echo ${result/e/*10^} | tr -d "+"` 
    result=${result:--1}
    
    [[ result != -1 ]] && echo -e "Ajuste: f(x)=$2\n" >> "$1.fit" && cat tmp >> "$1.fit"
    
    rm -f tmp
    
    echo -e "\n\n##########################################################################\n\n" >> "$1.fit"
}


# param $1 "nombre del algoritmo (mergesort, heapsort,...)"
# param $2 "función de ajuste"
# param $3 "coeficientes de la función de ajuste correspondiente"
#
# Hace un plot del .dat junto a la función que más se le ajusta de
# entre las disponibles en FUNCS
#
function plotajuste() {
    # linea de depuración: echo "$1: $2"
    echo "set xlabel 'Talla del problema(n)'
        set ylabel 'Tiempo(s)'
        set terminal jpeg size 800,480
        set output '$1_fit.jpg'
        f(x)=$2
        fit f(x) '$1.dat' via $3
        plot '$1.dat',f(x) title 'Curva ajustada' with linespoints" > $SCRIPT
    echo "****   Función de mejor ajuste: $2   *****" >> "$1.fit"
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
    echo -n "" > "$1.fit"
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
        
        if [[ `echo "($result < $mejor)" | bc -l` -eq 1 ]] && [[ $result != -1 ]]
        then
            mejor=$result
            chosen=$i
        fi
    done
    
    plotajuste $1 $(echo ${FUNCS[$chosen]} | cut -f1 -d " ") $(echo ${FUNCS[$chosen]} | cut -f2 -d " ")

}

# param $1 "nombre del/los algoritmo(s) (mergesort, heapsort,...)"
# 
# Genera una tabla de datos a partir del .dat de los algoritmos dados 
#
function gentable() {
    TEXFILE="table$(echo "$1" | egrep -o "\b[[:alnum:]]{1}" | tr -d "\n").tex"
    touch $TEXFILE || exit -1

    echo -n "\\begin{center}
    \\begin{longtabu} to \linewidth{ l | *{`echo $1 | wc -w`}{d{10}}}  % máx 10 decimales
\rowfont\bfseries Tamaño " > $TEXFILE

    first=0

    for file in $1; do
        [[ $first -eq 0 ]] && NLINES=`cat $file.dat | wc -l` && first=1
        echo -n "& \multicolumn{1}{l}{$file} " >> $TEXFILE
    done

    echo "\\\\ \\hline
    \endhead
    \endfoot
    \\\\ \\hline
    \endlastfoot" >> $TEXFILE

    for (( i = 1; i <= $NLINES; i++ )); do
        first=0 # true
        for file in $1; do
            line=`sed "$i q;d" $file.dat`
            time=`echo $line | cut -d" " -f2 | sed "s/0\{1,\}$//;s/^\./0\./"`
            
            [[ $first -eq 0 ]] && {
                tam=`echo $line | cut -d" " -f1`
                echo -n "$tam " >> $TEXFILE
                first=1 # false
            }

            echo -n "& $time " >> $TEXFILE
        done
        echo "\\\\" >> $TEXFILE
    done

    echo "
    \\end{longtabu}
\\end{center}" >> $TEXFILE
}

# Extraemos el nombre del source a partir del path
PN=${1##*/}

# Si el argumento del script es 0, hacemos un plot de datos
# Si es 1, generamos el .dat correspondiente al archivo pasado
# Si es 2, generamos un plot del ajuste al .dat del archivo pasado
# Si es 3, generamos una tabla LaTeX a partir de los .dat de los programas dados

[[ $2 -eq 0 ]] && genplot $PN && exit 0

[[ $2 -eq 1 ]] && gendata $PN && exit 0

[[ $2 -eq 2 ]] && genajuste $PN && exit 0

[[ $2 -eq 3 ]] && gentable "$1" && exit 0

exit 1
