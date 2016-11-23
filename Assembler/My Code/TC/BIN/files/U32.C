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


   void  fDekTaska(double x, double y, char spalva){

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



//=======================================
// Pirma versija su Daug C kodo ir FPU skaiciavimu
//=======================================

double distanceFromPoint(double x1, double y1, double x2, double y2){
  double result = 0;
  asm{
    finit
    fld x1
    fsub x2
    fabs
    fmul st,st        //st(0) = |x1 - x2|^2
    fld y1
    fsub y2
    fabs
    fmul st,st        //st(0) = |y1 - y2|^2 ; st(1) = |x1 - x2|^2
    fadd st(0),st(1)
    fsqrt
    fst result      //result = (|y1 - y2|^2 + |x1 - x2|^2)^(1/2)
    fwait
  }


  //printf("%f\n",result );
  return result;
}
int inRange(double x1, double y1, double r1, double x2, double y2, double r2, double t1, double t2){
  if((distanceFromPoint(x1,y1,t1,t2)<r1)&&(distanceFromPoint(x2,y2,t1,t2)<r2)){
    return 1;
  }else{
    return 0;
  }
}


void skrituliuSankirtaC(double x1, double y1, double r1, double x2, double y2, double r2, char spalva){
  unsigned int i =0;
  unsigned int j =0;
  for(;i<320;i++){
    j=0;
    for(;j<200;j++){
        if (inRange(x1,y1,r1,x2,y2,r2,i,j)==1){
          fDekTaska(i,j,spalva);
        }
      }
    }
    fDekTaska(x1,y1,'f');
    fDekTaska(x2,y2,'f');
}



//===================================
//antra versija su minimaliai C kodo
//===================================
int gerasAtstumas(double x1, double y1, double r1, double x2, double y2, double r2, double t1, double t2){
	unsigned int result = 0;
	unsigned int busena = 0;
//pirmas skritulys
	asm{
    finit
    fld x1
    fsub t1
    fabs
    fmul st,st        //st(0) = |x1 - t1|^2
    fld y1
    fsub t2
    fabs
    fmul st,st        //st(0) = |y1 - t2|^2 ; st(1) = |x1 - t1|^2
    fadd st(0),st(1)
    fsqrt
    fcom r1      //result = (|y1 - t2|^2 + |x1 - t1|^2)^(1/2)
	  fstsw busena;
    fwait

  	mov ax,0000000100000000b
  	AND ax,busena    //gaunam c0
  	cmp ax,0000000100000000b
  	jne tooBig

//antras sritulys

    finit
    fld x2
    fsub t1
    fabs
    fmul st,st        //st(0) = |x2 - t1|^2
    fld y2
    fsub t2
    fabs
    fmul st,st        //st(0) = |y1 - t2|^2 ; st(1) = |x1 - t1|^2
    fadd st(0),st(1)
    fsqrt
    fcom r2      //result = (|y1 - t2|^2 + |x1 - t1|^2)^(1/2)
	  fstsw busena;
    fwait

  	mov ax,0000000100000000b
  	AND ax,busena      //gaunam c0
  	cmp ax,0000000100000000b
  	jne tooBig

  	mov ax,1     //taskas yra abiejuose skrituliu reziuose
  	mov result, ax
	}
tooBig:

  return result;
}


void skrituliuSankirta(double x1, double y1, double r1, double x2, double y2, double r2, char spalva){
unsigned int i = 0;
unsigned int j = 0;
unsigned int result = 0;

tesk: //ciklo pradzia
	result = gerasAtstumas(x1,y1,r1,x2,y2,r2,i,j); //tikriname taska
	asm{
		mov ax, result
		cmp ax,1 //if result != 1
		jne nepiesk
	}
	fDekTaska(i,j,spalva);
nepiesk:
	asm{
		mov ax, j
		inc ax
		mov j,ax          //j++
		cmp ax, 200       // if j>200
		jg naujasCiklas
		jmp tesk
	}
naujasCiklas:
	asm{
		xor ax,ax
    mov j, ax         //j = 0
		mov ax, i
		inc ax
		mov i,ax          //i++
		cmp ax, 320       //if i>320
		jg endThis
		jmp tesk:
	}
	endThis:
  fDekTaska(x1,y1,'f'); //Pazymim centrus atskira spalva
  fDekTaska(x2,y2,'f');
}

int main(){

double array[6] = {10,10,10,-10,-10,50};//lengvas argumentu ivedimas
char spalva = 2;
  grafika();
  spalvinkViska(0); // fonas
  delay(500);

  skrituliuSankirtaC(array[0],array[1],array[2],array[3],array[4],array[5],'c'); //Kodas Su C (Leciau dirba)
  delay(1000);
  skrituliuSankirta(array[0],array[1],array[2],array[3],array[4],array[5],spalva); // Kodas su asm
  //turetu uzspalvoti
  delay(2000);

  //tekstas();
  printf("%s\n","Paspausti enter mygtuka" );
  getchar();


  return 0;

}
