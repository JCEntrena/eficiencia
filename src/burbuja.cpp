/**
 * @file Ordenación por burbuja
 */

#include <iostream>
#include <ctime>
#include <cstdlib>
#include <ctime>
using namespace std;

/**
 * @brief Ordena un vector por el método de la burbuja.
 * @param T: vector de elementos. Debe tener num_elem elementos.
 * Es modificado.
 * @param num_elem: número de elementos. num_elem > 0.
 * 
 * Cambia el orden de los elementos de T de forma que los dispone
 * en sentido creciente de menor a mayor.
 * Aplica el algoritmo de la burbuja.
 */

inline static void burbuja(int T[], int num_elem);

/**
 * @brief Ordena parte de un vector por el método de la burbuja.
 * @param T: vector de elementos. Tiene un número de elementos
 * mayor o igual a final.Es MODIFICADO.
 * @param inicial: Posición que marca el incio de la parte del
 * vector a ordenar.
 * @param final: Posición detrás de la última de la parte del
 * vector a ordenar.
 * inicial < final.
 * 
 * Cambia el orden de los elementos de T entre las posiciones
 * inicial y final - 1de forma que los dispone en sentido creciente
 * de menor a mayor.
 * Aplica el algoritmo de la burbuja.
 */

static void burbuja_lims(int T[], int inicial, int final);

// Implementación

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
    burbuja (T,n);
    clock_gettime(CLOCK_REALTIME,&t_despues);
    
    cout.precision(3);
    cout << (double) (t_despues.tv_sec-t_antes.tv_sec)+
        (double) ((t_despues.tv_nsec-t_antes.tv_nsec)/(1.e+9)) << endl;

    
    delete [] T;
    
    return 0;
}