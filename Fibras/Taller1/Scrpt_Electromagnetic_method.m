%%%%%%%%%%%%%% MÉTODO eLECTROMAGNETICO/ SLN USANDO LA RUTINA DE %%%%%%%%%%%
%%%%%%%%%%%%%%    NEWTON RAPHSON PARA SISTEMAS NO LINEALES    %%%%%%%%%%%%%

%% Similar al caso del método de rayos, solo basta con definir las funciones 
% de tal manera que se pueda visualizar los cortes con las funciones
% respectivas.
num_of_points = 1000000;
n_co = 1.5;
n_cl = 1;
n_s = n_cl;
h = 1e-6;
lambda = 1e-6;
k_0 = 2*pi/lambda;
mu0 = 4*pi*10^-7; 
c0 = physconst('LightSpeed');
eps_n_co = (1/mu0)*(n_co/c0)^2;
eps_n_cl = (1/mu0)*(n_cl/c0)^2;
imp_co = sqrt(mu0/eps_n_co);
omega = (k_0*n_co/sqrt(mu0*eps_n_co));

V = (k_0*h/2)*sqrt((n_co^2-n_cl^2));

if (V < pi/2)
    num_of_asints_tan = 0;
else
    num_of_asints_tan = 1 + floor((V - pi/2)/pi);
end

if (V < pi)
    num_of_asints_cot = 0;
else
    num_of_asints_cot = 1 + floor((V - pi)/pi);
end

fTE_pares = @(x) x.*tan(x);
fTE_impares = @(x) -x.*cot(x);

fTM_pares = @(x) (n_cl/n_co)^2*x.*tan(x);
fTM_impares = @(x) -(n_cl/n_co)^2*x.*cot(x);

circ_TETM = @(x) sqrt(V^2-x.^2);


xrtan = zeros(num_of_asints_tan + 1,num_of_points/(num_of_asints_tan + 1));
xrcot = zeros(num_of_asints_cot + 1,num_of_points/(num_of_asints_cot + 1));

xrcir = linspace(0,V,num_of_points);


if (V < pi/2) && (V < pi)
    xrtan = linspace(0,V,num_of_points);
    xrcot = linspace(0,V,num_of_points);
elseif  (V < pi) 
    xrcot = linspace(0,V,num_of_points);
    for i = 1:num_of_asints_tan + 1
        if (i == 1)
            xrtan(i,:) = linspace(0,pi/2,num_of_points/(num_of_asints_tan + 1));
        else
            xrtan(i,:) = linspace(0.001 + xrtan(i-1,num_of_points/(num_of_asints_tan + 1)) ...
                                , 3*pi/2 + (i-2)*pi, num_of_points/(num_of_asints_tan + 1));
        end
    end
else
    for i = 1:num_of_asints_tan + 1
        if (i == 1)
            xrtan(i,:) = linspace(0,pi/2,num_of_points/(num_of_asints_tan + 1));
        else
            xrtan(i,:) = linspace(0.001 + xrtan(i-1,num_of_points/(num_of_asints_tan + 1)) ...
                                , 3*pi/2 + (i-2)*pi, num_of_points/(num_of_asints_tan + 1));
        end
    end

    for i = 1:num_of_asints_cot + 1
        
        if (i == 1)
            xrcot(i,:) = linspace(0 , pi, num_of_points/(num_of_asints_cot + 1));
        else
            xrcot(i,:) = linspace(0.001 + xrcot(i-1,num_of_points/(num_of_asints_cot + 1)) ...
                                , 2*pi + (i-2)*pi, num_of_points/(num_of_asints_cot + 1));
        end
    end
end




figure;
sgtitle('Método Electromagnético');

FTE_pares = zeros(num_of_asints_tan + 1, num_of_points/(num_of_asints_tan + 1));
FTE_impares = zeros(num_of_asints_cot + 1, num_of_points/(num_of_asints_cot + 1));

subplot(1,2,1);
hold on;

Traces1 = gobjects(1,num_of_asints_tan + num_of_asints_cot + 2 + 1);

for i = 1:num_of_asints_tan + 1
    FTE_pares(i,:) = fTE_pares(xrtan(i,:));
    Traces1(i) = plot(xrtan(i,:),FTE_pares(i,:),'LineWidth', 1.5);
end

for i = 1:num_of_asints_cot + 1
    FTE_impares(i,:) = fTE_impares(xrcot(i,:));
    Traces1(num_of_asints_tan + 1 + i) = plot(xrcot(i,:),FTE_impares(i,:),'LineWidth', 1.5);
end

Cir = circ_TETM(xrcir);


Traces1(end) = plot(xrcir,Cir,'LineWidth', 1.5);

xlabel('$\kappa \frac{h}{2}$','FontWeight', 'bold', 'FontSize', 16, 'FontName', 'Arial', 'Interpreter', 'latex');
ylabel('$\gamma \frac{h}{2}$','FontWeight', 'bold', 'FontSize', 16, 'FontName', 'Arial', 'Interpreter', 'latex');
xlim([0,V+1]);
ylim([0,V+1]);
title('Modos TE')
legend(Traces1 , {'$y = xtan(x)$ (modo 0)','$y = xtan(x)$ (modo 2)','$y = -xcot(x)$ (modo 1)', ...
        '$x^{2} + y^{2}= (\frac{k_{0}h}{2})^{2}(n^{2}_{co}-n^{2}_{cl})$'},'Interpreter', 'latex');

hold off;

FTM_pares = zeros(num_of_asints_tan + 1, num_of_points/(num_of_asints_tan + 1));
FTM_impares = zeros(num_of_asints_cot + 1, num_of_points/(num_of_asints_cot + 1));

Traces2 = gobjects(1,num_of_asints_tan + num_of_asints_cot + 2 + 1);

subplot(1,2,2);
hold on;

for i = 1:num_of_asints_tan + 1
    FTM_pares(i,:) = fTM_pares(xrtan(i,:));
    Traces2(i) = plot(xrtan(i,:),FTM_pares(i,:),'LineWidth', 1.5);
end

for i = 1:num_of_asints_cot + 1
    FTM_impares(i,:) = fTM_impares(xrcot(i,:));
    Traces2(num_of_asints_tan + 1 + i) = plot(xrcot(i,:),FTM_impares(i,:),'LineWidth', 1.5);
end

Cir = circ_TETM(xrcir);

Traces2(end) = plot(xrcir,Cir,'LineWidth', 1.5);

xlabel('$\kappa \frac{h}{2}$','FontWeight', 'bold', 'FontSize', 16, 'FontName', 'Arial', 'Interpreter', 'latex');
ylabel('$\gamma \frac{h}{2}$','FontWeight', 'bold', 'FontSize', 16, 'FontName', 'Arial', 'Interpreter', 'latex');
xlim([0,V+1]);
ylim([0,V+1]);
title('Modos TM')
legend(Traces2 , {'$y = (\frac{n_{cl}}{n_{co}})^{2} xtan(x)$ (modo 0)', ...
        '$y = (\frac{n_{cl}}{n_{co}})^{2}xtan(x)$ (modo 2)','$y = -(\frac{n_{cl}}{n_{co}})^{2}xcot(x)$ (modo 1)', ...
        '$x^{2} + y^{2}= (\frac{k_{0}h}{2})^{2}(n^{2}_{co}-n^{2}_{cl})$'},'Interpreter', 'latex');

hold off;


%% Hallados los modos para cada tipo de polarizacion TE y TM  ahora falta caracterizarlos, entonces
% las intersecciones de cada grafica con la circunferencia.


%% Para modos TE 

% Definimos la funcion vectorial la cual representara nuestro sitema de
% ecuaciones no lineal.

UTE_par = @(x,y) [y - x.*tan(x), x.^2 + y.^2 - V^2];
UTE_impar = @(x,y) [y + x.*cot(x), x.^2 + y.^2 - V^2];

JUTE_par = @(x,y) [-tan(x)-x.*(sec(x)).^2 ,1 ;2*x , 2*y];
JUTE_impar = @(x,y) [cot(x)-x.*(csc(x)).^2 ,1 ;2*x , 2*y];

[P0_TE, iter0_TE, err0_TE , Y0_TE] = newdim (UTE_par, JUTE_par, [1,3]  , 1e-3, 1e-4, 1000);
[P1_TE, iter1_TE, err1_TE , Y1_TE] = newdim (UTE_impar, JUTE_impar, [2.5,2.5]  , 1e-3, 1e-4, 1000);
[P2_TE, iter2_TE, err2_TE , Y2_TE] = newdim (UTE_par, JUTE_par, [3,1]  , 1e-3, 1e-4, 1000);


%% Para modos TM

% Definimos la funcion vectorial la cual representara nuestro sitema de
% ecuaciones no lineal.

UTM_par   = @(x,y) [y - (n_cl/n_co)^2*x.*tan(x) , x.^2 + y.^2 - V^2];
UTM_impar = @(x,y) [y + (n_cl/n_co)^2*x.*cot(x) , x.^2 + y.^2 - V^2];

JUTM_par = @(x,y) [(-tan(x)-x.*(sec(x)).^2)*(n_cl/n_co)^2 ,1 ;2*x , 2*y];
JUTM_impar = @(x,y) [(cot(x)-x.*(csc(x)).^2)*(n_cl/n_co)^2 ,1 ;2*x , 2*y];

[P0_TM, iter0_TM, err0_TM , Y0_TM] = newdim (UTM_par, JUTM_par, [1.23,3.28]  , 1e-3, 1e-4, 1000);
[P1_TM, iter1_TM, err1_TM , Y1_TM] = newdim (UTM_impar, JUTM_impar, [2.5,2.5]  , 1e-3, 1e-4, 1000);
[P2_TM, iter2_TM, err2_TM , Y2_TM] = newdim (UTM_par, JUTM_par, [3,1]  , 1e-3, 1e-4, 1000);

%% Ya se encontraron los angulos de incidencia de cada modo y la cantidad de
% modos , solo falta hallar el beta de cada uno y el indice efectivo, por
% lo que se hara una tabla en la cual se mostraran los datos.


% matrx_resutls_TE = zeros(4,3);
% 
% for i = 1:4
%     switch i
%         case 1
% 
%             matrx_resutls_TE(i,:) = 1:size(matrx_resutls_TE(i,:)) -1;
% 
%         case 2
% 
%             matrx_resutls_TE(i,:) = ;
% 
%         case 3
% 
% 
%         case 4
% 
% 
%         otherwise
%     end
%     matrx_resutls_TE(i,:) = ;
% end

%% Para modos TE

modo_TE = 0:2;

Beta_TE = zeros(1,length(modo_TE));

b1 = sqrt((k_0*n_co)^2-(P0_TE(1)*2/h)^2);
b2 = sqrt((P0_TE(2)*2/h)^2+(k_0*n_cl)^2);
b = (b1+b2)/2;

Beta_TE(1) =  b;


b1 = sqrt((k_0*n_co)^2-(P1_TE(1)*2/h)^2);
b2 = sqrt((P1_TE(2)*2/h)^2+(k_0*n_cl)^2);
b = (b1+b2)/2;

Beta_TE(2) =  b;

b1 = sqrt((k_0*n_co)^2-(P2_TE(1)*2/h)^2);
b2 = sqrt((P2_TE(2)*2/h)^2+(k_0*n_cl)^2);
b = (b1+b2)/2;

Beta_TE(3) =  b;

n_Efectivo_TE = [Beta_TE(1)/k_0, Beta_TE(2)/k_0, Beta_TE(3)/k_0];
Angulo_TE = [asind(n_Efectivo_TE(1)/n_co), ...
             asind(n_Efectivo_TE(2)/n_co), ...
             asind(n_Efectivo_TE(3)/n_co)];

% Create the table for TE modes
TTE = table(modo_TE', Beta_TE', n_Efectivo_TE', Angulo_TE', ...
'VariableNames', {'Modo', 'Beta [m^-1]', 'Índice efectivo','Ángulo de incidencia[°]'});
disp("/////////////////// Descripción modos TE (EM) ////////////////////////")
disp(TTE);


%% Para modos TM

modo_TM = 0:2;

Beta_TM = zeros(1,length(modo_TM));

b1 = sqrt((k_0*n_co)^2-(P0_TM(1)*2/h)^2);
b2 = sqrt((P0_TM(2)*2/h)^2+(k_0*n_cl)^2);
b = (b1+b2)/2;

Beta_TM(1) =  b;


b1 = sqrt((k_0*n_co)^2-(P1_TM(1)*2/h)^2);
b2 = sqrt((P1_TM(2)*2/h)^2+(k_0*n_cl)^2);
b = (b1+b2)/2;

Beta_TM(2) =  b;

b1 = sqrt((k_0*n_co)^2-(P2_TM(1)*2/h)^2);
b2 = sqrt((P2_TM(2)*2/h)^2+(k_0*n_cl)^2);
b = (b1+b2)/2;

Beta_TM(3) =  b;

n_Efectivo_TM = [Beta_TM(1)/k_0, Beta_TM(2)/k_0, Beta_TM(3)/k_0];

Angulo_TM = [asind(n_Efectivo_TM(1)/n_co), ...
             asind(n_Efectivo_TM(2)/n_co), ...
             asind(n_Efectivo_TM(3)/n_co)];

% Create the table for TM modes
TTM = table(modo_TM', Beta_TM', n_Efectivo_TM', Angulo_TM', 'VariableNames', ...
    {'Modo', 'Beta [m^-1]', 'Índice efectivo','Ángulo de incidencia[°]'});
disp("///////////////////  Descripción modos TM  (EM) ////////////////////////")
disp(TTM);


%% Creamos ahora las graficas Ey y Hx transversales para modos TE y Hy, Ex para modos 
% TM por lo que podremos saber el perfil transversal de los modos que
% aparecen, un plus que en el método de rayos no podremos resolver con
% precisión.

% los kappa y gamma de cada uno de las soluciones halladas para TE
p0_TE = P0_TE * 2/h;
p1_TE = P1_TE * 2/h;
p2_TE = P2_TE * 2/h;

% los kappa y gamma de cada uno de las soluciones halladas para TM
p0_TM = P0_TM * 2/h;
p1_TM = P1_TM * 2/h;
p2_TM = P2_TM * 2/h;




% Para modos pares la relacion entre las amplitudes C0 y C1 es 

C1 = 1; % Vamos a considerar que C1 = 1 por facilidad ya que solo nos interesa para este ejemplo
        % la forma de la grafica en sentido transversal, mas no sus valores
        % exactos
C0_par = @(kappa) C1*cos(kappa*h/2);

% Para modos impares la relacion entre las amplitudes C0 y C1 es 
C0_impar = @(kappa) C1*sin(kappa*h/2);

% MODOS TE

Ey_0TE = @(x)     C0_par(p0_TE(1)) .* exp(-p0_TE(2).*(abs(x)-h/2)) .* ( abs(x) > h/2 ) ...
                + C1.*cos(p0_TE(1)*x) .* (abs(x) <= h/2);

Ey_1TE = @(x)     C0_impar(p1_TE(1)) .* exp(-p1_TE(2)*(x-h/2)) .* ( x > h/2 ) ...
                + C1*sin(p1_TE(1)*x) .* (abs(x) <= h/2) ...
                - C0_impar(p1_TE(1)) .* exp(p1_TE(2)*(x+h/2)) .* ( x < -h/2 );

Ey_2TE = @(x)     C0_par(p2_TE(1)) .* exp(-p2_TE(2)*(abs(x)-h/2)) .* ( abs(x) > h/2 ) ...
                + C1*cos(p2_TE(1)*x) .* (abs(x) <= h/2);


Hx_0TE = @(x)   -Beta_TE(1)/(omega*mu0) .* ...
                  (C0_par(p0_TE(1)) .* exp(-p0_TE(2).*(abs(x)-h/2)) .* ( abs(x) > h/2 ) ...
                + C1*cos(p0_TE(1)*x) .* (abs(x) <= h/2));

Hx_1TE = @(x)   -Beta_TE(2)/(omega*mu0) .* (C0_impar(p1_TE(1)) .* exp(-p1_TE(2)*(x-h/2)) .* ( x > h/2 ) ...
                + C1*sin(p1_TE(1)*x) .* (abs(x) <= h/2) ...
                - C0_impar(p1_TE(1)) .* exp(p1_TE(2)*(x+h/2)) .* ( x < -h/2 ));

Hx_2TE = @(x)   -Beta_TE(3)/(omega*mu0) .* ...
                  (C0_par(p2_TE(1)) .* exp(-p2_TE(2).*(abs(x)-h/2)) .* ( abs(x) > h/2 ) ...
                + C1*cos(p2_TE(1)*x) .* (abs(x) <= h/2));


% MODOS TM

Hy_0TM = @(x)     C0_par(p0_TM(1)) .* exp(-p0_TM(2).*(abs(x)-h/2)) .* ( abs(x) > h/2 ) ...
                + C1*cos(p0_TM(1)*x) .* (abs(x) <= h/2);

Hy_1TM = @(x)     C0_impar(p1_TM(1)) .* exp(-p1_TM(2).*(x-h/2)) .* ( x > h/2 ) ...
                + C1*sin(p1_TM(1)*x) .* (abs(x) <= h/2) ...
                - C0_impar(p1_TM(1)) .* exp(p1_TM(2).*(x+h/2)) .* ( x < -h/2 );

Hy_2TM = @(x)     C0_par(p2_TM(1)) .* exp(-p2_TM(2).*(abs(x)-h/2)) .* ( abs(x) > h/2 ) ...
                + C1*cos(p2_TM(1)*x) .* (abs(x) <= h/2);


Ex_0TM = @(x)    (Beta_TM(1)/(omega*eps_n_cl)) .* ...
                 C0_par(p0_TM(1)) .* exp(-p0_TM(2).*(abs(x)-h/2)) .* ( abs(x) > h/2 ) ...
                 +                               ...   
                 (Beta_TM(1)/(omega*eps_n_co)) .* ... 
                 C1*cos(p0_TM(1)*x) .* (abs(x) <= h/2);




Ex_1TM = @(x) (Beta_TM(2)/(omega*eps_n_cl)) .* ... 
         (C0_impar(p1_TM(1))) * exp(-p1_TM(2)*(x - h/2)) .* ( x > h/2 )+                               ...
                 (Beta_TM(2)/(omega*eps_n_co)) .* ...
                 C1*sin(p1_TM(1)*x) .* (abs(x) <= h/2)-(Beta_TM(2)/(omega*eps_n_cl)) * ...
            C0_impar(p1_TM(1)) * exp(p1_TM(2)*(x + h/2)) .* ( x < -h/2 );

Ex_2TM = @(x)   (Beta_TM(3)/(omega*eps_n_cl)) .* ...
                 C0_par(p2_TM(1)) * exp(-p2_TM(2)*(abs(x)-h/2)) .* ( abs(x) > h/2 )+ ...
                 (Beta_TM(3)/(omega*eps_n_co)) .* ...
                 C1*cos(p2_TM(1)*x) .* (abs(x) <= h/2);


x_trans = linspace(-1e-6,1e-6,100);

cursor_position0 = 0;
cursor_position1 = h/2;
cursor_position2 = -h/2; 

figure;
sgtitle('Sección Transversal de Modos TE');


%% GRAFICAMOS PRIMERO LOS MODOS TE

subplot(2,3,1)
plot(Ey_0TE(x_trans), x_trans, 'LineWidth', 1.5);
yline(cursor_position0, 'k', 'LineWidth', 1); 
yline(cursor_position1, 'r', 'LineWidth', 1);  % Add vertical red dashed line
yline(cursor_position2, 'r', 'LineWidth', 1);  % Add vertical red dashed line
title ("Ey m = 0 Modo TE");

subplot(2,3,2)
plot(Ey_1TE(x_trans), x_trans, 'LineWidth', 1.5);
yline(cursor_position0, 'k', 'LineWidth', 1); 
yline(cursor_position1, 'r', 'LineWidth', 1);  % Add vertical red dashed line
yline(cursor_position2, 'r', 'LineWidth', 1);  % Add vertical red dashed line
title ("Ey m = 1 Modo TE");


subplot(2,3,3)
plot(Ey_2TE(x_trans), x_trans, 'LineWidth', 1.5);
yline(cursor_position0, 'k', 'LineWidth', 1); 
yline(cursor_position1, 'r', 'LineWidth', 1);  % Add vertical red dashed line
yline(cursor_position2, 'r', 'LineWidth', 1);  % Add vertical red dashed line
title ("Ey m = 2 Modo TE");



subplot(2,3,4)
plot(Hx_0TE(x_trans), x_trans, 'LineWidth', 1.5);
yline(cursor_position0, 'k', 'LineWidth', 1); 
yline(cursor_position1, 'r', 'LineWidth', 1);  % Add vertical red dashed line
yline(cursor_position2, 'r', 'LineWidth', 1);  % Add vertical red dashed line
title ("Hx m = 0 Modo TE");

subplot(2,3,5)
plot(Hx_1TE(x_trans), x_trans, 'LineWidth', 1.5);
yline(cursor_position0, 'k', 'LineWidth', 1); 
yline(cursor_position1, 'r', 'LineWidth', 1);  % Add vertical red dashed line
yline(cursor_position2, 'r', 'LineWidth', 1);  % Add vertical red dashed line
title ("Hx m = 1 Modo TE");


subplot(2,3,6)
plot(Hx_2TE(x_trans), x_trans, 'LineWidth', 1.5);
yline(cursor_position0, 'k', 'LineWidth', 1); 
yline(cursor_position1, 'r', 'LineWidth', 1);  % Add vertical red dashed line
yline(cursor_position2, 'r', 'LineWidth', 1);  % Add vertical red dashed line
title ("Hx m = 2 Modo TE");


figure;
sgtitle('Sección Transversal de Modos TM');


%% GRAFICAMOS PRIMERO LOS MODOS TM

subplot(2,3,1)
plot(Hy_0TM(x_trans), x_trans, 'LineWidth', 1.5);
yline(cursor_position0, 'k', 'LineWidth', 1); 
yline(cursor_position1, 'r', 'LineWidth', 1);  % Add vertical red dashed line
yline(cursor_position2, 'r', 'LineWidth', 1);  % Add vertical red dashed line
title ("Hy m = 0 Modo TM");

subplot(2,3,2)
plot(Hy_1TM(x_trans), x_trans, 'LineWidth', 1.5);
yline(cursor_position0, 'k', 'LineWidth', 1); 
yline(cursor_position1, 'r', 'LineWidth', 1);  % Add vertical red dashed line
yline(cursor_position2, 'r', 'LineWidth', 1);  % Add vertical red dashed line
title ("Hy m = 1 Modo TM");


subplot(2,3,3)
plot(Hy_2TM(x_trans), x_trans, 'LineWidth', 1.5);
yline(cursor_position0, 'k', 'LineWidth', 1); 
yline(cursor_position1, 'r', 'LineWidth', 1);  % Add vertical red dashed line
yline(cursor_position2, 'r', 'LineWidth', 1);  % Add vertical red dashed line
title ("Hy m = 2 Modo TM");



subplot(2,3,4)
plot(Ex_0TM(x_trans), x_trans, 'LineWidth', 1.5);
yline(cursor_position0, 'k', 'LineWidth', 1); 
yline(cursor_position1, 'r', 'LineWidth', 1);  % Add vertical red dashed line
yline(cursor_position2, 'r', 'LineWidth', 1);  % Add vertical red dashed line
title ("Ex m = 0 Modo TM");


subplot(2,3,5)
plot(Ex_1TM(x_trans), x_trans, 'LineWidth', 1.5);
yline(cursor_position0, 'k', 'LineWidth', 1); 
yline(cursor_position1, 'r', 'LineWidth', 1);  % Add vertical red dashed line
yline(cursor_position2, 'r', 'LineWidth', 1);  % Add vertical red dashed line
title ("Ex m = 1 Modo TM");


subplot(2,3,6)
plot(Ex_2TM(x_trans), x_trans, 'LineWidth', 1.5);
yline(cursor_position0, 'k', 'LineWidth', 1); 
yline(cursor_position1, 'r', 'LineWidth', 1);  % Add vertical red dashed line
yline(cursor_position2, 'r', 'LineWidth', 1);  % Add vertical red dashed line
title ("Ex m = 2 Modo TM");

