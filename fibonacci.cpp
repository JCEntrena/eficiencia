/**
 * @file Cálculo de la sucesión de Fibonacci
 */

#include <iostream>
#include <ctime>
#include <cstdlib>
using namespace std;

/**
 * @brief Calcula el término n-ésimo de la sucesión de Fibonacci.
 * @param n: número de orden del término buscado. n >= 1.
 * @return: término n-ésimo de la sucesión de Fibonacci.
 */

int fibo(int n){
    if (n < 2)
        return 1;
    else
        return fibo(n-1) + fibo(n-2);
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
    fibo (n);
    clock_gettime(CLOCK_REALTIME,&t_despues);
    
    cout.precision(3);
    cout << (double) (t_despues.tv_sec-t_antes.tv_sec)+
        (double) ((t_despues.tv_nsec-t_antes.tv_nsec)/(1.e+9)) << endl;
    
    return 0;
}