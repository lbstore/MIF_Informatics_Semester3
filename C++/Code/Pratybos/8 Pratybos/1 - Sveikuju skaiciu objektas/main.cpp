#include <string>
#include <iostream>
#include "int.h"
using namespace std;


int main() {

  int numbers[] = { 0, 12, 5, 7, 5, 7 };

  // Apskaičiuojam masyvo dydį (elemetų kiekį)
  const int isize = sizeof numbers / sizeof *numbers;

  Int inter;
  const Int inter1;

  for(int i = 0; i < isize; i++)
    inter.insert(&numbers[i]);

 // Negalima nes inter1 yra konstantinis
 //for(int i = 0; i < isize; i++)
   //inter1.insert(&numbers[i]);

  // Atspauzdinam kas yra mūsų objekte
  inter.printAll();


} 
