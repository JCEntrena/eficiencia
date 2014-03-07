#include <iostream>
using namespace std;
#include <ctime>
#include <cstdlib>
#include <climits>
#include <cassert>

#define NUM_VECES 10000

inline static void burbuja(int T[], int num_elem);

static void burbuja_lims(int T[], int inicial, int final);

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
    t_transcurrido = (double)(t_despues-t_antes-t_b)/(CLOCKS_PER_SEC*(double)(NUM_VECES));
    delete [] T;
    delete [] U;
    
    cout << t_transcurrido << endl;
    return 0;
}