//: C10:OverridingAmbiguity.cpp
// From Thinking in C++, 2nd Edition
// Available at http://www.BruceEckel.com
// (c) Bruce Eckel 2000
// Copyright notice in Copyright.txt
#include "NamespaceMath.h"
#include "NamespaceCalculation.h"


int main() {
  using namespace Math;

  // 2 būdas
  using Math::divide;

  using namespace Calculation;

  Integer i1(1);
  Integer i2(2);

  // 2 būdas
  divide(i1, i2); 

  // 1 būdas
  //Math::divide(i1, i2); 

} 
