//: C10:NamespaceInt.h
// From Thinking in C++, 2nd Edition
// Available at http://www.BruceEckel.com
// (c) Bruce Eckel 2000
// Copyright notice in Copyright.txt
#ifndef NAMESPACEINT_H
#define NAMESPACEINT_H

namespace Int {

  class Integer {
    int i;
    char sign;
  public:
    Integer(int ii = 0) {
    		i = ii;
    		if (ii >= 0) sign = '+';
    		else sign = '-';
    }
      
    char getSign() { return sign; }
    void setSign(char sgn) { sign = sgn; }
    // ...
  };
} 
#endif 
