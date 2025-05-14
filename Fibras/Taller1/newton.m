function  [p0, err, k, y] = newton (f, df, p0,delta, epsilon, max1)

% Entrada - f funcion creada con @
%         - df funcion derivada creada con @
%         - p0 es la aproximacion inicial a cero de  f
%	      - delta es la tolerancia para  p0
%	      - epsilon es la tolerancia para los valores de la funcion  y
%	      - max1 es el numero maximo de iteraciones
% Salida  - p0 es la aproximacion de Newton-Raphson hacia cero
%	      - err es el error estimado para  p0
%	      - k es el numero de iteraciones
%	      - y es el valor de la funcion  f(p0)

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompa�ando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

for  k = 1:max1	
	p1 = p0 - feval(f, p0) / feval(df, p0);
%%	err = abs(p1 - p0);
    err = 10;
%%	relerr = 2 * err / (abs(p1) + delta);
    relerr = 10;
	p0 = p1;
	y = feval(f, p0);
    if  (err < delta)  |  (relerr < delta)  |  (abs(y) < epsilon), break, end
end    
