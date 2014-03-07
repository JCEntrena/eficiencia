/**
 * @file Cálculo de la sucesión de Fibonacci
 */

#include <iostream>
#include <ctime>
using namespace std;

#define NUM_VECES 10000

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
        cerr << "Uso del programa: " + (string)(argv[0]) + " <número entero>" << endl;  
        return -1;
    }
    int n = atoi(argv[1]);
    clock_t t_antes, t_despues
    
    t_antes = clock();
    for (int i=0; i<NUM_VECES; ++i){
        fib(n);
    t_despues = clock();

    cout << (double)(t_despues-t_antes)/(CLOCKS_PER_SEC);
    return 0;
}