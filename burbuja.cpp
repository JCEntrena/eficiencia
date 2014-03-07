/**
@file Ordenación por burbuja
*/

#include <iostream>
using namespace std;
#include <ctime>
#include <cstdlib>
#include <climits>
#include <cassert>
#include <ctime>
#include <unistd.h>

#define NUM_VECES 10000



/* ************************************************************ */
/* Método de ordenación por burbuja */

/**
@brief Ordena un vector por el método de la burbuja.

@param T: vector de elementos. Debe tener num_elem elementos.
Es MODIFICADO.
@param num_elem: número de elementos. num_elem > 0.

Cambia el orden de los elementos de T de forma que los dispone
en sentido creciente de menor a mayor.
Aplica el algoritmo de la burbuja.
*/

inline static void burbuja(int T[], int num_elem);

/**
@brief Ordena parte de un vector por el método de la burbuja.

@param T: vector de elementos. Tiene un número de elementos
mayor o igual a final.Es MODIFICADO.

@param inicial: Posición que marca el incio de la parte del
vector a ordenar.
@param final: Posición detrás de la última de la parte del
vector a ordenar.
inicial < final.

Cambia el orden de los elementos de T entre las posiciones
inicial y final - 1de forma que los dispone en sentido creciente
de menor a mayor.
Aplica el algoritmo de la burbuja.
*/

static void burbuja_lims(int T[], int inicial, int final);

/**
Implementación de las funciones
**/


inline void burbuja(int T[], int num_elem){
    burbuja_lims(T, 0, num_elem);
}

static void burbuja_lims(int T[], int inicial, int final){
    int i, j;
    int aux;
    for (i = inicial; i < final - 1; i++)
        for (j = final - 1; j > i; j--)
            if (T[j] < T[j-1])
            {
                aux = T[j];
                T[j] = T[j-1];
                T[j-1] = aux;
            }
}

void duplicaVector(int* T,int* U,int tam){
    for (int i=0; i<tam; ++i){
        U[i]=T[i];
    }
}

int main(int argc, char* argv[]){
    if (argc !=2){
        cerr << "Uso del programa: " + (string)(argv[0]) + " <número entero>" << endl;  
        return -1;
    }
    int n = atoi(argv[1]);
    int * T = new int[n], *U=new int[n];
    double t_transcurrido;
    clock_t t_antes, t_despues, t_a, t_b(0);
    
    srandom(time(0));
    
    for (int i=0; i<n; ++i){
        T[i] = random();
    }
    
    t_antes = clock();
    for (int i=0; i<NUM_VECES; ++i){
        t_a=clock();
        duplicaVector(T,U,n);
        t_b+=(clock()-t_a);
        burbuja(U, n);
    }
    t_despues = clock();
    delete [] T;
    delete [] U;
    
    cout << (double)(t_despues-t_antes-t_b)/(CLOCKS_PER_SEC*(double)(NUM_VECES));
    return 0;
}