/**
 * @file Ordenación por selección
 */

#include <iostream>
#include <ctime>
#include <cstdlib>
#include <ctime>
#include <cassert>
#include <climits>
using namespace std;

/**
 * @brief Ordena un vector por el método de selección.
 * @param T: vector de elementos. Debe tener num_elem elementos.
 * Es modificado.
 * @param num_elem: número de elementos. num_elem > 0.
 * 
 * Cambia el orden de los elementos de T de forma que los dispone
 * en sentido creciente de menor a mayor.
 * Aplica el algoritmo de selección.
 */

inline static void seleccion(int T[], int num_elem);

/**
 * @brief Ordena parte de un vector por el método de selección.
 * @param T: vector de elementos. Tiene un número de elementos 
 * mayor o igual a final. Es MODIFICADO.
 * @param inicial: Posición que marca el incio de la parte del
 * vector a ordenar.
 * @param final: Posición detrás de la última de la parte del
 * vector a ordenar. 
 * @pre inicial < final.
 * 
 * Cambia el orden de los elementos de T entre las posiciones
 * inicial y final - 1de forma que los dispone en sentido creciente
 * de menor a mayor.
 * Aplica el algoritmo de selección.
 */

static void seleccion_lims(int T[], int inicial, int final);

// Implementación de las funciones

void seleccion(int T[], int num_elem){
    seleccion_lims(T, 0, num_elem);
}

static void seleccion_lims(int T[], int inicial, int final){
    int i, j, indice_menor;
    int menor, aux;
    for (i = inicial; i < final - 1; i++) {
        indice_menor = i;
        menor = T[i];
        for (j = i; j < final; j++)
            if (T[j] < menor) {
                indice_menor = j;
                menor = T[j];
            }
            aux = T[i];
        T[i] = T[indice_menor];
        T[indice_menor] = aux;
    }
}
 
/**
 * @brief Permite duplicar un vector de enteros
 * @param T puntero a un vector de enteros
 * @param U puntero a otro vector de enteros
 * @param n tamanio de ambos vectores
 * @pre Han de tener el mismo tamanio
 */

void duplicaVector(int* T,int* U,int tam){
    for (int i=0; i<tam; ++i){
        U[i]=T[i];
    }
}

int main(int argc, char* argv[]){
    if (argc !=2){
        cerr << "Uso del programa: " + (string)(argv[0]) + " <número positivo>" << endl;  
        return -1;
    }
    int n = atoi(argv[1]);    
    if (n<0) return -1;
    
    int * T = new int[n];
    struct timespec t_antes, t_despues;
    
    srandom(time(0));
    
    for (int i=0; i<n; ++i){
        T[i] = random();
    }
    
    clock_gettime(CLOCK_REALTIME,&t_antes);
    seleccion (T,n);
    clock_gettime(CLOCK_REALTIME,&t_despues);
    
    cout.precision(3);
    cout << (double) (t_despues.tv_sec-t_antes.tv_sec)+
        (double) ((t_despues.tv_nsec-t_antes.tv_nsec)/(1.e+9)) << endl;

    
    delete [] T;
    
    return 0;
}