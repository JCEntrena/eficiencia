/**
 * @file Ordenación por montones
 */

#include <iostream>
#include <ctime>
#include <cstdlib>
#include <ctime>
using namespace std;

#define NUM_VECES 10000

/**
 * @brief Ordena un vector por el método de montones.
 * @param T: vector de elementos. Debe tener num_elem elementos.
 * Es modificado.
 * @param num_elem: número de elementos. num_elem > 0.
 * 
 * Cambia el orden de los elementos de T de forma que los dispone
 * en sentido creciente de menor a mayor.
 * Aplica el algoritmo de ordenación por montones.
 * 
 */

inline static void heapsort(int T[], int num_elem);

/**
 * @brief Reajusta parte de un vector para que sea un montón.
 * @param T: vector de elementos. Debe tener num_elem elementos.
 * Es modificado.
 * @param num_elem: número de elementos. num_elem > 0.
 * @param k: índice del elemento que se toma com raíz
 *   
 * Reajusta los elementos entre las posiciones k y num_elem - 1 
 * de T para que cumpla la propiedad de un montón (APO), 
 * considerando al elemento en la posición k como la raíz.
 */

static void reajustar(int T[], int num_elem, int k);

// Implementación de las funciones

static void heapsort(int T[], int num_elem){
    int i;
    for (i = num_elem/2; i >= 0; i--)
        reajustar(T, num_elem, i);
    for (i = num_elem - 1; i >= 1; i--){
        int aux = T[0];
        T[0] = T[i];
        T[i] = aux;
        reajustar(T, i, 0);
    }
}


static void reajustar(int T[], int num_elem, int k){
    int j;
    int v;
    v = T[k];
    bool esAPO = false;
    while ((k < num_elem/2) && !esAPO){
        j = k + k + 1;
        if ((j < (num_elem - 1)) && (T[j] < T[j+1]))
            j++;
        if (v >= T[j])
            esAPO = true;
        T[k] = T[j];
        k = j;
    }
    T[k] = v;
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
        heapsort(U, n);
    }
    t_despues = clock();
    
    delete [] T;
    delete [] U;
    
    cout << (double)(t_despues-t_antes-t_b)/(CLOCKS_PER_SEC*(double)(NUM_VECES)) << endl;
    return 0;
}
