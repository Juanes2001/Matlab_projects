%%%%%%%%%%%%%%%%%% MÉTODO DE RAYOS/ SLN USANDO LA RUTINA DE %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%     NEWTON RAPHSON     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% La idea es usar el metodo de newton esperando a que nuestra funcion 
% trascendente no tenga ceros de segundo orden para arriba, para ello vamos
% a graficar primero la función para ver su cero primero que cumpla:

%  1. Que su valor si se encuentre dentro del rango permitido por la
%  estructura.
%  2. Que el cero correspondiente pueda ser encontrado por el metodo de
%  Newton, condicion para que exista convergencia hacia el
%  cero deseado de forma rapida y eficiente.

%% Comenzamos escribiendo la funcion de tal forma que variamos el parametro 
% m para hallar la cantidad de modos en la guía.

fTE = @(x,m) 2.*cosd(x)-(2/pi).*atan((1./(1.5*cosd(x))).*sqrt((1.5)^2.*(sind(x)).^2-1) ) - m; 
fTM = @(x,m) 2.*cosd(x)-(2/pi).*atan((1.5./(cosd(x))).*sqrt((1.5)^2.*(sind(x)).^2-1) ) - m; 

num_points = 1000000;
mind = 41.8104;
maxd= 89.9999;

% Creamos el dominio, particionamos de tal forma que podamos ver en el
% intervalo de interes si existe algun cero comenzando con el orden m = 0:

xd = linspace(mind,maxd,num_points);
z = zeros(1,num_points);

%% Comenzamos para modos TE

cursor_position = 0 ; 
figure;
sgtitle('MODOS TE');


%% PARA m = 0
m = 0;
F = fTE(xd,z + m);

subplot(2,2,1);
plot(xd,F);
grid on;
xlim([mind, maxd]); 

yline(cursor_position, 'r--', 'LineWidth', 2);  % Add vertical red dashed line

title("m = 0");

%% PARA m = 1

m = 1;
F = fTE(xd,z + m);

subplot(2,2,2);
plot(xd,F);
grid on;
xlim([mind, maxd]);
yline(cursor_position, 'r--', 'LineWidth', 2);  % Add vertical red dashed line

title("m = 1");

%% PARA m = 2

m = 2;
F = fTE(xd,z + m);

subplot(2,2,3);
plot(xd,F);
grid on;
xlim([mind, maxd]);
yline(cursor_position, 'r--', 'LineWidth', 2);  % Add vertical red dashed line

title("m = 2");

%% PARA m = 2

m = 3;
F = fTE(xd,z + m);

subplot(2,2,4);
plot(xd,F);
grid on;
xlim([mind, maxd]);
yline(cursor_position, 'r--', 'LineWidth', 2);  % Add vertical red dashed line

title("m = 3");


%% Ahora para modos TM

cursor_position = 0 ; 
figure;
sgtitle('MODOS TM');


%% PARA m = 0
m = 0;
F = fTM(xd,z + m);

subplot(2,2,1);
plot(xd,F);
grid on;
xlim([mind, maxd]); 

yline(cursor_position, 'r--', 'LineWidth', 2);  % Add vertical red dashed line

title("m = 0");

%% PARA m = 1

m = 1;
F = fTM(xd,z + m);

subplot(2,2,2);
plot(xd,F);
grid on;
xlim([mind, maxd]);
yline(cursor_position, 'r--', 'LineWidth', 2);  % Add vertical red dashed line

title("m = 1");

%% PARA m = 2

m = 2;
F = fTM(xd,z + m);

subplot(2,2,3);
plot(xd,F);
grid on;
xlim([mind, maxd]);
yline(cursor_position, 'r--', 'LineWidth', 2);  % Add vertical red dashed line

title("m = 2");

%% PARA m = 2

m = 3;
F = fTM(xd,z + m);

subplot(2,2,4);
plot(xd,F);
grid on;
xlim([mind, maxd]);
yline(cursor_position, 'r--', 'LineWidth', 2);  % Add vertical red dashed line

title("m = 3");


%% Ahora ya encontrado los modos, tenemos que solo hay 2 modos los cuales viajan
% dentro de la guía de vidrio. Ahora falta hallar el cero de cada funcion
% ya que representara entonces el ángulo de incidencia del modo a la
% interfase. Hallamos la derivada de la funcion f:

dfTE = @(x) -2*sind(x) - (2/pi)*(1./( (1./( (1.5)^2 * (cosd(x)).^2) ) .* (1.5^2 * (sind(x)).^2 - 1) + 1 ) ) .*  ...
            ( (1/1.5) * ( (sind(x)./ (cos(x)).^2 )  .* sqrt(1.5^2 * (sind(x)).^2 - 1) + (1./cosd(x)).*(1.5^2 * ...
            sind(x).*cosd(x))./sqrt(1.5^2 * (sind(x)).^2 -1 ) ) );

dfTM = @(x) -2*sind(x) - (2/pi)*(1./( ((1.5)^2./((cosd(x)).^2) ) .* (1.5^2 * (sind(x)).^2 - 1) + 1 ) ) .*  ...
            ( (1.5) * ( (sind(x)./ (cos(x)).^2 )  .* sqrt(1.5^2 * (sind(x)).^2 - 1) + (1./cosd(x)).*(1.5^2 * ...
            sind(x).*cosd(x))./sqrt(1.5^2 * (sind(x)).^2 -1 ) ) );


% d2fTE = @(x) -2*cosd(x)-(2/pi)*( ( ( -(1/1.5^2)* (  ((2*sind(x))./(cosd(x)).^2).*(1.5^2*(sind(x)).^2 - 1)  + ...
%             (2./(cosd(x)).^2).* (1.5^2*sind(x).*cosd(x)) )    )./ ((  (1./(1.5*cosd(x)).^2).*(1.5^2*(sind(x)).^2 - 1 ) + 1  ).^2) ) .* ...
%              ( (1/1.5) * ( (sind(x)./ (cos(x)).^2 )  .* sqrt(1.5^2 * (sind(x)).^2 - 1) + (1./cosd(x)).*(1.5^2 * ...
%             sind(x).*cosd(x))./sqrt(1.5^2 * (sind(x)).^2 -1 ) ) )   + (1./( (1./( (1.5)^2 * (cosd(x)).^2) ) .* (1.5^2 * (sind(x)).^2 - 1) + 1 ) ).* ...
%               (  (1/1.5)* ( (( (cosd(x)).^3 +2*(sind(x)).^2 .*cosd(x) )./ ( (cosd(x)).^4 ) ).* sqrt(1.5^2 * (sind(x)).^2 - 1) + ... 
%                ( sind(x)./( (cosd(x)).^2 )  ).* ( (1.5^2 * sind(x).*cosd(x))./sqrt(1.5^2 * (sind(x)).^2 -1 ) ) )  +  (1.5^2/1.5) * ( ...
%                ( sind(x)./( (cosd(x)).^2 )  ).* ( (sind(x).*cosd(x))./sqrt(1.5^2 * (sind(x)).^2 -1 ) ) + (1./cosd(x)).* ...
%                ( (sqrt(1.5^2 * (sind(x)).^2 -1 ).*((cosd(x)).^2 - (sind(x)).^2) - sind(x).*cosd(x).*...
%                ( (1.5^2 * sind(x).*cosd(x))./sqrt(1.5^2 * (sind(x)).^2 -1 ) ) )./ (1.5^2 * (sind(x)).^2 -1) ) ) )  );
% 
% d2fTM = @(x) -2*cosd(x)-(2/pi)*( ( ( -(1.5^2)* (  ((2*sind(x))./(cosd(x)).^2).*(1.5^2*(sind(x)).^2 - 1)  + ...
%             (2./(cosd(x)).^2).* (1.5^2*sind(x).*cosd(x)) )    )./ ((  ((1.5./cosd(x)).^2).*(1.5^2*(sind(x)).^2 - 1 ) + 1  ).^2) ) .* ...
%              ( (1.5) * ( (sind(x)./ (cos(x)).^2 )  .* sqrt(1.5^2 * (sind(x)).^2 - 1) + (1./cosd(x)).*(1.5^2 * ...
%             sind(x).*cosd(x))./sqrt(1.5^2 * (sind(x)).^2 -1 ) ) ) + (1./( ((1.5)^2./((cosd(x)).^2) ) .* (1.5^2 * (sind(x)).^2 - 1) + 1 ) ).* ...
%             (  (1.5)* ( (( (cosd(x)).^3 +2*(sind(x)).^2 .*cosd(x) )./ ( (cosd(x)).^4 ) ).* sqrt(1.5^2 * (sind(x)).^2 - 1) + ... 
%                ( sind(x)./( (cosd(x)).^2 )  ).* ( (1.5^2 * sind(x).*cosd(x))./sqrt(1.5^2 * (sind(x)).^2 -1 ) ) )  +  (1.5^3) * ( ...
%                ( sind(x)./( (cosd(x)).^2 )  ).* ( (sind(x).*cosd(x))./sqrt(1.5^2 * (sind(x)).^2 -1 ) ) + (1./cosd(x)).* ...
%                ( (sqrt(1.5^2 * (sind(x)).^2 -1 ).*((cosd(x)).^2 - (sind(x)).^2) - sind(x).*cosd(x).*...
%                ( (1.5^2 * sind(x).*cosd(x))./sqrt(1.5^2 * (sind(x)).^2 -1 ) ) )./ (1.5^2 * (sind(x)).^2 -1) ) ) )  );

f0TE = @(x) fTE(x,0);
f1TE = @(x) fTE(x,1);


f0TM = @(x) fTM(x,0);
f1TM = @(x) fTM(x,1);

%% Para m = 0, usamos rutina newton para hallar el modo con un error de 10^-4
% debido a la presición que se está manejando en el intervalo.

[p0TE, err0TE, k0TE, y0TE] = newton(f0TE, dfTE, 70, 1E-3, 1E-4, 100000);
[p0TM, err0TM, k0TM, y0TM] = newton(f0TM, dfTM, 65, 1E-3, 1E-4, 100000);

%% Para m = 1, usamos rutina newton para hallar el modo con un error de 10^-4
% debido a la presición que se está manejando en el intervalo.

[p1TE, err1TE, k1TE, y1TE] = newton(f1TE, dfTE, 49, 1E-3, 1E-4, 100000);
[p1TM, err1TM, k1TM, y1TM] = newton(f1TM, dfTM, 44, 1E-3, 1E-4, 100000);


%% Ya se encontraron los angulos de incidencia de cada modo y la cantidad de
% modos , solo falta hallar el beta de cada uno y el indice efectivo, por
% lo que se hara una tabla en la cual se mostraran los datos.

modo_TE = [0;1];
Beta_TE = [ ((2*pi)/1e-6) *1.5* sind(p0TE); ((2*pi)/1e-6) *1.5* sind(p1TE)];
n_Efectivo_TE = [1.5* sind(p0TE); 1.5* sind(p1TE)];
Angulo_TE = [p0TE;p1TE];

% Create the table for TE modes
TTE = table(modo_TE, Beta_TE, n_Efectivo_TE,Angulo_TE, 'VariableNames', {'Modo', 'Beta', 'Índice efectivo','Ángulo de incidencia'});
disp("/////////////////// Descripción modos TE ////////////////////////")
disp(TTE);

modo_TM = [0;1];
Beta_TM = [ ((2*pi)/1e-6) *1.5* sind(p0TM); ((2*pi)/1e-6) *1.5* sind(p1TM)];
n_Efectivo_TM = [1.5* sind(p0TM); 1.5* sind(p1TM)];
Angulo_TM = [p0TM;p1TM];

% Create the table for TM modes
TTM = table(modo_TM, Beta_TM, n_Efectivo_TM,Angulo_TM, 'VariableNames', {'Modo', 'Beta', 'Índice efectivo','Ángulo de incidencia'});
disp("/////////////////// Descripción modos TM ////////////////////////")
disp(TTM);