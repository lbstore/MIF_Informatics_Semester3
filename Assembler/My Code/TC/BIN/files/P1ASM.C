#include <stdio.h>
#include <conio.h>
#include <stdlib.h>

char ribos(long double x, long double y, long double R){
// tikrina ar x^2 + y^2 < R^2
  char res = 0;
  unsigned int busena;
  long double rezulatas;
  asm{
    // skaiciuojame x^2 + y^2 - R^2
    finit;
    fld x;
    fmul ST(0), ST(0);

    fld y;
    fmul ST(0), ST(0);

    fadd ST(0), ST(1);

    fld R;
    fmul ST(0), ST(0);

    fsubr ST(0), ST(1)

    fstp rezulatas;
    fld rezulatas;

    // tikriname zenkla:

    ftst              // ST(0) ir +0.0
    fstsw busena      // Saugome busenos zodi
    fwait             //
    mov ax, busena    // Busenos zodis -> AX
    sahf              //
    jpe klaida        // jeigu klaida
    jae   neneigiamas //
    mov res, 1
    jmp pabaiga
    }
  neneigiamas:

   asm{
      mov res, 0;
  }

  pabaiga:
  printf("\n %5.3Lf \n", rezulatas);

  return res;

  klaida:
  printf("Skaciavimo klaida\n");
  return -1;
}

int main(){
   long double x,y,R;
   printf("\n");
   scanf("%Lf%Lf%Lf", &x, &y, &R);
   printf("Ar nutoles nuo (0,0) daugiau uz %5.2Lf: %d \n", R, ribos(x,y,R));
   return 0;
}
