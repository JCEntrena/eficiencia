/**
 * @file mergesort.cpp
 * Ordenación por mezcla
 */

#include <iostream>
#include <ctime>
#include <cstdlib>
#include <cassert>
#include <climits>
using namespace std;

#define NUM_VECES 50

/**
 * @brief Ordena un vector por el método de mezcla.
 * @param T Vector de elementos. Debe tener num_elem elementos.
 * @param num_elem: número de elementos. num_elem > 0.
 * @pos El vector contiene los elementos ordenados.
 * 
 * Cambia el orden de los elementos de T de forma que los dispone
 * en sentido creciente de menor a mayor.
 * Aplica el algoritmo de mezcla.
 */

inline static void mergesort(int T[], int num_elem);

/**
 * @brief Ordena parte de un vector por el método de mezcla.
 * @param T: vector de elementos. Tiene un número de elementos 
 * mayor o igual a final. Es MODIFICADO.
 * @param inicial: Posición que marca el incio de la parte del
 * vector a ordenar.
 * @param final: Posición detrás de la última de la parte del
 * vector a ordenar. 
 * @pre inicial < final.
 * 
 * Cambia el orden de los elementos de T entre las posiciones
 * inicial y final - 1 de forma que los dispone en sentido creciente
 * de menor a mayor.
 * Aplica el algoritmo de la mezcla.
 */

static void mergesort_lims(int T[], int inicial, int final);

/**
 * @brief Ordena un vector por el método de inserción.
 * @param T: vector de elementos. Debe tener num_elem elementos.
 * Es modificado.
 * @param num_elem: número de elementos. num_elem > 0.
 * 
 * Cambia el orden de los elementos de T de forma que los dispone
 * en sentido creciente de menor a mayor.
 * Aplica el algoritmo de inserción.
 */

inline static void insercion(int T[], int num_elem);

/**
 * @brief Ordena parte de un vector por el método de inserción.
 * @param T: vector de elementos. Tiene un número de elementos 
 * mayor o igual a final. Es MODIFICADO.
 * @param inicial: Posición que marca el incio de la parte del
 * vector a ordenar.
 * @param final: Posición detrás de la última de la parte del
 * vector a ordenar. 
 * @pre inicial < final.
 * 
 * Cambia el orden de los elementos de T entre las posiciones
 * inicial y final - 1 de forma que los dispone en sentido creciente
 * de menor a mayor.
 * Aplica el algoritmo de la inserción.
 */

static void insercion_lims(int T[], int inicial, int final);

/**
 * @brief Mezcla dos vectores ordenados sobre otro.
 * @param T: vector de elementos. Tiene un número de elementos 
 * mayor o igual a final. Es MODIFICADO.
 * @param inicial: Posición que marca el incio de la parte del
 * vector a escribir.
 * @param final: Posición detrás de la última de la parte del
 * vector a escribir
 * inicial < final.
 * @param U: Vector con los elementos ordenados.
 * @param V: Vector con los elementos ordenados.
 * @pre El número de elementos de U y V sumados debe coincidir
 * con final - inicial.
 * 
 * En los elementos de T entre las posiciones inicial y final - 1
 * pone ordenados en sentido creciente, de menor a mayor, los
 * elementos de los vectores U y V.
 */

static void fusion(int T[], int inicial, int final, int U[], int V[]);

// Implementación de las funciones

inline static void insercion(int T[], int num_elem){
    insercion_lims(T, 0, num_elem);
}

static void insercion_lims(int T[], int inicial, int final){
    int i, j;
    int aux;

    for (i = inicial + 1; i<final; i++){
        j = i;
        while ((T[j] < T[j-1]) && (j > 0)){
            aux = T[j];
            T[j] = T[j-1];
            T[j-1] = aux;
            j--;
        }
    }
}

const int UMBRAL_MS = 100;

void mergesort(int T[], int num_elem){
    mergesort_lims(T, 0, num_elem);
}

static void mergesort_lims(int T[], int inicial, int final){
    if ((final - inicial) < UMBRAL_MS) {
        insercion_lims(T, inicial, final);
    }
    else {
        int k = (final - inicial)/2;
        
        int* U = new int [k - inicial + 1];
        assert(U);
        int l, l2;
        for (l = 0, l2 = inicial; l < k; l++, l2++)
            U[l] = T[l2];
        U[l] = INT_MAX;
        
        int* V = new int [final - k + 1];
        assert(V);
        for (l = 0, l2 = k; l < final - k; l++, l2++)
            V[l] = T[l2];
        V[l] = INT_MAX;
        
        mergesort_lims(U, 0, k);
        mergesort_lims(V, 0, final - k);
        fusion(T, inicial, final, U, V);
        delete [] U;
        delete [] V;
    }
}


static void fusion(int T[], int inicial, int final, int U[], int V[]) {
    // Toma el mínimo entre los restantes de los vectores U y V,
    // colocará ese mínimo en T y moverá el índice de lectura.
    int j = 0;
    int k = 0;

    for (int i = inicial; i < final; i++) {
        if (U[j] < V[k]) {
            T[i] = U[j];
            j++;
        }
        else {
            T[i] = V[k];
            k++;
        }
    }
}

int main(int argc, char* argv[]) {
    if (argc != 2){
        cerr << "Uso del programa: " + (string)(argv[0]) + " <número positivo>" << endl;  
        return -1;
    }

    int n = atoi(argv[1]);    
    if (n<0) return -1;
    
    int * T = new int[n];
    struct timespec t_antes, t_despues;
    
    // Vector aleatorio.
    srandom(time(0));
    for (int i=0; i<n; ++i) {
        T[i] = random();
    }
    
    // Medida del tiempo. Ejecución del algoritmo.
    clock_gettime(CLOCK_REALTIME,&t_antes);
    mergesort(T,n);
    clock_gettime(CLOCK_REALTIME,&t_despues);
    
    
    cout.precision(3);
    cout << (double) (t_despues.tv_sec-t_antes.tv_sec)+
        (double) ((t_despues.tv_nsec-t_antes.tv_nsec)/(1.e+9)) << endl;

    delete [] T;
    
    return 0;
}
