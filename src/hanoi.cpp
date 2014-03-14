/**
 * @file Resolución del problema de las Torres de Hanoi
 */

#include <iostream>
#include <cstdlib>
#include <ctime>
using namespace std;

/**
 * @brief Resuelve el problema de las Torres de Hanoi
 * @param M: número de discos. M > 1.
 * @param i: número de columna en que están los discos.
 * i es un valor de {1, 2, 3}. i != j.
 * @param j: número de columna a que se llevan los discos.
 * j es un valor de {1, 2, 3}. j != i.
 * 
 * Esta función imprime en la salida estándar la secuencia de
 * movimientos necesarios para desplazar los M discos de la
 * columna i a la j, observando la restricción de que ningún
 * disco se puede situar sobre otro de tamaño menor. Utiliza
 * una única columna auxiliar.
 */

void hanoi (int M, int i, int j);

void hanoi (int M, int i, int j){
    if (M > 0){
        hanoi(M-1, i, 6-i-j);
        //cout << i << " -> " << j << endl;
        hanoi (M-1, 6-i-j, j);
    }
}

int main(int argc, char* argv[]){
    if (argc !=2){
        cerr << "Uso del programa: " + (string)(argv[0]) + " <número positivo>" << endl;  
        return -1;
    }
    int n = atoi(argv[1]);    
    if (n<0) return -1;

    struct timespec t_antes, t_despues;
    
    clock_gettime(CLOCK_REALTIME,&t_antes);
    hanoi (n,1,2);
    clock_gettime(CLOCK_REALTIME,&t_despues);
    
    cout.precision(3);
    cout << (double) (t_despues.tv_sec-t_antes.tv_sec)+
        (double) ((t_despues.tv_nsec-t_antes.tv_nsec)/(1.e+9)) << endl;
    
    return 0;
}