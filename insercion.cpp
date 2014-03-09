/**
 * @file Ordenación por inserción
 */

#include <iostream>
#include <ctime>
#include <cstdlib>
#include <ctime>
using namespace std;

#define NUM_VECES 500
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
 * inicial y final - 1de forma que los dispone en sentido creciente
 * de menor a mayor.
 * Aplica el algoritmo de inserción.
 */

static void insercion_lims(int T[], int inicial, int final);

// Implementación de las funciones

inline static void insercion(int T[], int num_elem){
    insercion_lims(T, 0, num_elem);
}

static void insercion_lims(int T[], int inicial, int final){
    int i, j;
    int aux;
    for (i = inicial + 1; i < final; i++){
        j = i;
        while ((T[j] < T[j-1]) && (j > 0)){
            aux = T[j];
            T[j] = T[j-1];
            T[j-1] = aux;
            j--;
        }
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
    
    int * T = new int[n], *U=new int[n];
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
        insercion(U, n);
    }
    t_despues = clock();
    
    delete [] T;
    delete [] U;
    
    cout << (double)(t_despues-t_antes-t_b)/(CLOCKS_PER_SEC*(double)(NUM_VECES)) << endl;
    return 0;
}
