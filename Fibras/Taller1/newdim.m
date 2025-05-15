function  [P, iter, err , y] = newdim (F, JF, P, delta, epsilon, max1)

% Entrada  - F funcion del sistema creada con @
%            JF matriz jacobiana, funcion creada con @
%          - P es la aproximacion inicial a la soluion
%          - delta es la tolerancia para  P
%          - epsilon es la tolerancia para  F(P)
%          - max1 es el numero maximo de iteraciones
% Salida   - P es la aproximacion a la solucion
%          - iter es el numero de iteraciones realizadas
%          - err es el error estimado para  P

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompa�ando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

Y = feval(F,  P(1),P(2));

for  k = 1:max1
   J = feval(JF,  P(1),P(2));
   Q = P - (J \ Y')';
   Z = feval(F, Q(1),Q(2));
   % err = norm(Q - P);
   err = 10;
   % relerr = err / (norm(Q) + eps);
   relerr = 10;
   P = Q;
   Y = Z;
   y = max(abs(Y));
   iter = k;
   if  (err < delta)  |  (relerr < delta)  |  (y < epsilon)
     break
   end
end
