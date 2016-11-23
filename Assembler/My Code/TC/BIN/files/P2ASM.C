#include <stdio.h>
#include <conio.h>
#include <stdlib.h>

   void grafika()
   {
      asm{
      mov     ax, 0013h
      int     10h
      };
   }


   void tekstas()
   {
      asm{
	mov     ax, 0003h
	int     10h
      }
   }

   void spalvinkViska( char spalva)
   {
      asm{
	push es;
	push di;
	push cx;

	mov al, spalva;
	mov ah, al;
	mov di, 0A000h;
	mov es, di;
	mov di, 0000h;
	mov cx, 32000;
	rep stosw;

	pop cx;
	pop di;
	pop es;

      }
   }


   void  fDekTaska(long double x, long double y, char spalva){

      unsigned int ix, iy; // word ;
      asm{
	finit
	// apvalinimas iki sveikuju:
	fld      x
	frndint
	fist     ix
	fld      y
	frndint
	fist     iy
	fwait

	// pakrauname i ES grafinio segmento adresa:

	push     es
	mov      ax, 0A000h
	mov      es, ax
	// tikriname ar koordinates tinkamos:
	mov      ax, iy
	cmp      ax, 199
	ja       isejimas
	mov      dx, ix
	cmp      dx, 319
	ja       isejimas
	//  pikselio adresas: ES:(320 * iy + ix)
	mov      cx, 320
	mul      cx
	add      ax, ix
	mov      bx, ax
	mov      al, spalva
	// dedame pikseli:
	mov      es:[bx], al
      }
	isejimas:
      asm {
	pop      es
      }
   }

void   elipse(unsigned int x, unsigned int y, unsigned int a,
		 unsigned int b, char spalva ){

	long double  dfi, fi,
		     xr, yr,
		     xr1, yr1, tg2, cosinus, sinus;
	unsigned int  i, du, tkst;

      asm {
	mov     tkst, 1000
	mov     du,   2
	mov     i,    0
	wait

	finit

	fldpi                   // ST(0) <- pi
	fidiv   tkst            // ST(0) /= 1000
 fidiv   du              // ST(0) /= 2

 fstp    dfi             // dfi <- ST(0) ir pop fpu

 fldz                    // 
 fstp    fi              // fi <- 0

	fwait

      }

      toliau:

      asm {
	finit
	fld     dfi
	fld     fi
	faddp   ST(1), ST(0)   // "fi += dfi"
	fstp  fi                // saugome fi

	fld fi                
	db 0D9h, 0FBh           //fsincos: tiesiog nera tokios mnemonikos
	fstp cosinus

	fld cosinus            // xr <- a * cos (fi)  + x
	fimul   a
	fiadd   x
	fstp     xr

	fld     cosinus       // xr1 <- x - a * cos (fi) 
	fimul   a
	fisubr  x
	fstp    xr1

	fstp sinus
	fld sinus             // yr <- b * sin (fi)  + y 
	fimul   b
	fiadd   y
	fstp     yr

	fld     sinus        // yr1 <- y -  b * sin (fi) 
	fimul   b
	fisubr  y
	fstp    yr1


	fwait

}
      fDekTaska(xr, yr, spalva);               // I ketvirtis
      fDekTaska(xr1, yr, spalva);              // II
      fDekTaska(xr, yr1, spalva);              // III
      fDekTaska(xr1, yr1, spalva);             // IV 

asm {
	mov     ax, i          
	inc     ax
	mov     i, ax
	cmp     ax, 1000           // tikriname ar ciklas baigesi 
	ja      pab
 jmp toliau
     }

	pab:

   }

int main(){

   grafika();

   spalvinkViska(3);
   while (!kbhit()) {
     elipse(rand() % 320, rand() % 200,
	    50 , 50,
	    15);

     delay(3000);
     spalvinkViska(3);
     delay(200);
     
   }
      
     

   tekstas();

   return 0;
      
}
