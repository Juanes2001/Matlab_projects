%%%%%%%%%%%%%% MÉTODO eLECTROMAGNETICO/ SLN USANDO LA RUTINA DE %%%%%%%%%%%
%%%%%%%%%%%%%%    NEWTON RAPHSON PARA SISTEMAS NO LINEALES    %%%%%%%%%%%%%

%% Similar al caso del método de rayos, solo basta con definir las funciones 
% de tal manera que se pueda visualizar los cortes con las funciones
% respectivas.
num_of_points = 100;
V = sqrt(pi^2*(1.5^2-1));

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

fTM_pares = @(x) (1/1.5)^2*x.*tan(x);
fTM_impares = @(x) -(1/1.5)^2*x.*cot(x);

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
                        + (i-2)*pi, 3*pi/2 + (i-2)*pi, num_of_points/(num_of_asints_tan + 1));
        end
    end
else
    for i = 1:num_of_asints_tan + 1
        if (i == 1)
            xrtan(i,:) = linspace(0,pi/2,num_of_points/(num_of_asints_tan + 1));
        else
            xrtan(i,:) = linspace(0.001 + xrtan(i-1,num_of_points/(num_of_asints_tan + 1)) ...
                            + (i-2)*pi, 3*pi/2 + (i-2)*pi, num_of_points/(num_of_asints_tan + 1));
        end
    end

    for i = 1:num_of_asints_cot + 1
        
        if (i == 1)
            xrcot(i,:) = linspace(0 , pi, num_of_points/(num_of_asints_cot + 1));
        else
            xrcot(i,:) = linspace(0.001 + xrcot(i-1,num_of_points/(num_of_asints_cot + 1)) ...
                            + (i-2)*pi, 2*pi + (i-2)*pi, num_of_points/(num_of_asints_cot + 1));
        end
    end
end




figure;
sgtitle('Método Electromagnético');

FTE_pares = zeros(num_of_asints_tan + 1, num_of_points/(num_of_asints_tan + 1));
FTE_impares = zeros(num_of_asints_cot + 1, num_of_points/(num_of_asints_cot + 1));

subplot(1,2,1);
hold on;

for i = 1:num_of_asints_tan + 1
    FTE_pares(i,:) = fTE_pares(xrtan(i,:));
    plot(xrtan(i,:),FTE_pares(i,:));
end

for i = 1:num_of_asints_cot + 1
    FTE_impares(i,:) = fTE_impares(xrcot(i,:));
    plot(xrcot(i,:),FTE_impares(i,:));
end

Cir = circ_TETM(xrcir);


plot(xrcir,Cir);

xlabel('$\kappa \frac{h}{2}$','FontWeight', 'bold', 'FontSize', 16, 'FontName', 'Arial', 'Interpreter', 'latex');
ylabel('$\gamma \frac{h}{2}$','FontWeight', 'bold', 'FontSize', 16, 'FontName', 'Arial', 'Interpreter', 'latex');
xlim([0,V+1]);
ylim([0,V+1]);
title('Modos TE')

hold off;

FTM_pares = zeros(num_of_asints_tan + 1, num_of_points/(num_of_asints_tan + 1));
FTM_impares = zeros(num_of_asints_cot + 1, num_of_points/(num_of_asints_cot + 1));

subplot(1,2,2);
hold on;

for i = 1:num_of_asints_tan + 1
    FTM_pares(i,:) = fTM_pares(xrtan(i,:));
    plot(xrtan(i,:),FTM_pares(i,:));
end

for i = 1:num_of_asints_cot + 1
    FTM_impares(i,:) = fTM_impares(xrcot(i,:));
    plot(xrcot(i,:),FTM_impares(i,:));
end

Cir = circ_TETM(xrcir);


plot(xrcir,Cir);

xlabel('$\kappa \frac{h}{2}$','FontWeight', 'bold', 'FontSize', 16, 'FontName', 'Arial', 'Interpreter', 'latex');
ylabel('$\gamma \frac{h}{2}$','FontWeight', 'bold', 'FontSize', 16, 'FontName', 'Arial', 'Interpreter', 'latex');
xlim([0,V+1]);
ylim([0,V+1]);
title('Modos TM')

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

UTM_par = @(x,y) [y - (1/1.5)^2*x.*tan(x), x.^2 + y.^2 - V^2];
UTM_impar = @(x,y) [y + (1/1.5)^2*x.*cot(x), x.^2 + y.^2 - V^2];

JUTM_par = @(x,y) [(-tan(x)-x.*(sec(x)).^2)*(1/1.5)^2 ,1 ;2*x , 2*y];
JUTM_impar = @(x,y) [(cot(x)-x.*(csc(x)).^2)*(1/1.5)^2 ,1 ;2*x , 2*y];

[P0_TM, iter0_TM, err0_TM , Y0_TM] = newdim (UTM_par, JUTM_par, [1,3]  , 1e-3, 1e-4, 1000);
[P1_TM, iter1_TM, err1_TM , Y1_TM] = newdim (UTM_impar, JUTM_impar, [2.5,2.5]  , 1e-3, 1e-4, 1000);
[P2_TM, iter2_TM, err2_TM , Y2_TM] = newdim (UTM_par, JUTM_par, [3,1]  , 1e-3, 1e-4, 1000);