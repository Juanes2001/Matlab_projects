%% ESTUDIO DE EL CRITERIO DE DIFERENCIACION DE DOMINIOS DE FRESNEL Y FRAUNHOFER

%%PARA FRAUNHOFER NO SE ELIMINARA LA FASE PARABOLICA EN EL PLANO DE LLEGADA
%%PARA MANTENER UN GRADO DE EXACTITUD EN EL RESULTADO, ASI QUE SOLO SE
%%ANALIZARA LA FASE PARABOLICA DE LLEGADA LA CUAL ESTA RELACIONADA CON LA
%%LAS DIMENSIONES DE LA APERTURA DE LA TRANSMITANCIA. SE VERA CON RESPECTO
%%A UN CAMPO DE ENTRADA CIRCULAR. Se analizara el error cometido al
%%considerar como limite de dominios el primer cero de el perfil parabólico

lambda = 600E-9; %en metros
num_of_points = 6E3;
z = 10000000; % en metros
k = (2*pi)/lambda;
first_zero = sqrt((z/k)*pi/2)-1.2;
dx = longitud/num_of_points;

longitud = 4;
diametro = longitud/2;
centro = longitud/2;

x = linspace(0,longitud,num_of_points);


square = (abs(x-centro) <= first_zero);
Re = cos((2*pi/(z*lambda)) * (x-centro).^2  );
Im = sin((2*pi/(z*lambda)) * (x-centro).^2  );


figure;
subplot(2,2,1);
plot(x,Re,x,square);
grid on;

subplot(2,2,2);
plot(x,Im,x,square);
grid on;

mult1 = square.* Re;
mult2 = square.* Im;

subplot(2,2,3);
plot(mult1);
grid on;

subplot(2,2,4);
plot(mult2);
grid on;

dx_out = (lambda*z)/(num_of_points*dx);

x_out = linspace(0,dx_out*num_of_points,num_of_points);

F_FTre = (mult1)*[exp(-1i*(k/z)*(x'*x_out))]; 
F_FTre = [F_FTre(num_of_points/2+1:num_of_points) F_FTre(1:num_of_points/2)];

F_FTim = 1i*(mult2)*[exp(-1i*(k/z)*(x'*x_out))]; 
F_FTim = [F_FTim(num_of_points/2+1:num_of_points) F_FTim(1:num_of_points/2)];


figure;
subplot(3,2,1);
plot(mult1);
grid on

subplot(3,2,3);
plot(abs(F_FTre));
grid on;

subplot(3,2,2);
plot(mult2);
grid on;

subplot(3,2,4);
plot(abs(F_FTim));
grid on;

subplot(3,2,5);
plot(abs(F_FTre + F_FTim));
grid on;

%Ahora para el caso de Fraunhofer


F_FT_fraun = (square)*[exp(-1i*(k/z)*(x'*x_out))];
F_FT_fraun = [F_FT_fraun(num_of_points/2+1:num_of_points) F_FT_fraun(1:num_of_points/2)];




figure;

subplot(2,1,1);
plot(square);
grid on;


subplot(2,1,2);
plot(abs(F_FT_fraun));
grid on;


%Comparacion entre ambos espectros 

err = abs(abs(F_FTre+F_FTim)-abs(F_FT_fraun))*100./abs(F_FTre+F_FTim);

figure;
plot(err);
grid on;
