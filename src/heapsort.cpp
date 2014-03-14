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
    for (i = num_elem/2; i >= 0; i--){
        reajustar(T, num_elem, i);
        for (j = num_elem - 1; j >= 1; j--){
            int aux = T[0];
            T[0] = T[j];
            T[j] = aux;
            reajustar(T, j, 0);
        }
    }
}


static void reajustar(int T[], int num_elem, int k){
    int j;
    int v;
    v = T[k];
    bool esAPO = false;
    while ((k < num_elem/2) && !esAPO){
        j = 2*k + 1;    //hijo a la izquierda de k
        if ((j < (num_elem - 1)) && (T[j] < T[j+1]))   //Si existe el hijo izquierda, coge el mayor de los hijos de k
            j++;
        if (v >= T[j])
            esAPO = true;
        T[k] = T[j];
        k = j;
    }
    T[k] = v;
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
    heapsort (T,n);
    clock_gettime(CLOCK_REALTIME,&t_despues);
    
    cout.precision(3);
    cout << (double) (t_despues.tv_sec-t_antes.tv_sec)+
        (double) ((t_despues.tv_nsec-t_antes.tv_nsec)/(1.e+9)) << endl;

    
    delete [] T;
    
    return 0;
}
