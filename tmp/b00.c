// Errores lexicos simples: 3 "warning" y 1 error lexico
//--------------------------------------------------------------------------
int abcdefghijklmnopqrstuwxyz;                 // identificador excesivo
int b;
int c#;                                        // error caracter desconocido

int doble(int x, int y, int z) 
{ int a; int b; int c;
  print(a=x++);
  print(b=++y);
  print(c=z);
  return a+b*c;
}

int main() 
{                                              
  abcdefghijklmn=b=c=3.56;     // contante real
  print(doble(abcdefghijklmnopqrstuwxyz,b,c)); // identificador excesivo
  return 0;
}
