%%%%%%%%%%%% IMPLEMENTACION DE LA DIFRACCION DE FRESNEL %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%       Y ESPECTRO ANGULAR           %%%%%%%%%%%%%%%%%%%%%%%%%%%


%% ELEMENTOS 
%  -- Sacar la transformada de Fourier de del campo de entrada
%  -- Multiplicar por la funcion de transferencia en aproximacion paraxial
%  -- Sacar la transformada de Fourier inversa para tener el campo optico
%  de salida.
%   
%   Para ello definir :
%   - distancia z a la cual se quiere hallar la difracción
%   - la longitud de onda
%   - longitud de muestreo
%   - numero de muestras, en este caso la cantidad de muestras debe de ser .
%   

% Vamos a suponer una ventana circular por donde pasará una onda plana
% monocromática , la luz chocará con la apertura circular de 1cm de diametro 
% con una longitud de onda de 600nm 

%Parametros
lambda = 600E-9;
longitud = 1E-5; %% Longitud en metros 
N = 200;
m = 5;
L = 1E-6;
z = N*(L^2)/lambda; %Distancia de propagacion entre planos (m)


%% funcion rectangulo, el cual sera nuestro campo optico de entrada con aplitud igual a 1
per = @(a,b) 1/2 * (1 + m*cos((2*pi*a/L)));
num_of_points = 3000; % Como la funcion rect no tiene limite en F_FFT_obanda entonces irse al limite de Nyquist no es util
                      % por lo que simplemente definimos muchas muestras en
                      % nuestra implementación


 
%% Los espaciamientos en x y en y definiran que tan buena sera la recontruccion 

dx = longitud/num_of_points;  %% Modificando esto podemos obtener la imagen como tal sin
dy = longitud/num_of_points;  %% Perdida de información
dfx = 1/(num_of_points* dx); %% steps en x del plano espectral Para un espaciamiento en limite de Nyquist
dfy = 1/(num_of_points* dy); %% Steps en y del plano espectral

x = linspace(0,(num_of_points-1)*dx,num_of_points);
y = linspace(0,(num_of_points-1)*dy,num_of_points);

u = linspace(0,(num_of_points-1)*dfx , num_of_points);
v = linspace(0,(num_of_points-1)*dfy , num_of_points);

% Creamos vectores de datos X, Y donde se va a contener cada valor de la maya 
[X,Y] = meshgrid(x,y);
[U,V] = meshgrid(u,v);

% Definimos la funcion f como el campo optico que se propagara y se
% difractará
f = per(X,Y);

%%Aumentamos la campo optico de entrada con zeros para mejorar la separacion de clones
% f = padding(f,10);
% 
% size_f = size(f);
% 
% %Cambiamos los parametros de salto entre puntos si es necesario, para el
% %caso de un padding, queremos cambiar la cantidad de muestras para
% %disminuir el espaciamiento entre muestras en el espectro
% 
% disp(dfx);
% disp(dx);
% 
% [dfx,dfy] = change_frequencial_parameters(dx,dy,size_f(1),size_f(2));
% 
% disp(dfx);
% disp(dx);
% 
% %Aumentamos tambien los dominios 
% [X,Y] = change_space_domain(dx,dy,size_f(1),size_f(2));
% [U,V] = change_spectral_domain(dfx,dfy,size_f(1),size_f(2));
% 
% num_of_points = size_f(1);

figure;
subplot(2,1,1);
imagesc(f);
title("Campo de entrada |f| (DFT)");


%% Implementacion por FFT

% Sacamos la transformada de Fourier del campo de entrada multiplicada por
% la fase parabolica de entrada en la apertura
% f_DFT_o = dft(z,lambda,X,Y,XO,YO,f.* exp(1i*(pi/(lambda*z))*(X.^2 + Y.^2)));
f_fft_o = fft2(f);
f_fft_o = shift(f_fft_o);
% f_DFT_o = shift(f_DFT_o);
% f_DFT_o = f_DFT_o./(max(max(abs(f_DFT_o))));
%F_FFT_o = abs(F_FFT_o);



% El siguiente paso es multiplicar el espectro angular de entrada por la 
% función de transferencia del espacio libre para así obtener el espectro
% angular del campo óptico de llegada posterior a la difracción

f_fft_s = f_fft_o .* exp(1i*(2*pi*z)/(lambda)).*exp(-1i*(pi*lambda*z) * ((U-(num_of_points*dfx)/2).^2 + ...
                                               (V-(num_of_points*dfy)/2).^2));

f_recontructed_fft = ifft2(f_fft_s);

subplot(2,1,2);
imagesc(abs(f_recontructed_fft).^2);
title("Campo Difractado |f| (FFT)")

colormap("gray");
colorbar("off");

%% Aqui vamos a crear una funcion que shiftea una matriz NxM

function shifted_matrix = shift(M)
        size_of = size(M); 

        M_shifted = zeros(size_of(1),size_of(2));

        % Primer cuadrante
        M_shifted(1:size_of(1)/2,1:size_of(2)/2) = ...
                        M(size_of(1)/2+1:size_of(1),size_of(2)/2+1:size_of(2));
        
        % Segundo Cuadrante
        M_shifted(1:size_of(1)/2,size_of(2)/2+1:size_of(2)) = ...
                        M(size_of(1)/2+1:size_of(1),1:size_of(2)/2);
        
        
        % Tercer Cuadrante
        M_shifted(size_of(1)/2+1:size_of(1),1:size_of(2)/2) = ...
                        M(1:size_of(1)/2,size_of(2)/2+1:size_of(2));

        % Cuarto Cuadrante 
        M_shifted(size_of(1)/2+1:size_of(1),size_of(2)/2+1:size_of(2)) = ...
                        M(1:size_of(1)/2,1:size_of(2)/2);

        shifted_matrix = M_shifted;

end

%% Con esta funcion hacemos un Padding a el campo de entrada 

function [M_padded,num_new_points] = padding(M,num_zeros)

        size_of = size(M);% encuentro la cantidad de filas y columnas

        M_to_pad = zeros(size_of(1) + num_zeros*2,size_of(2) + num_zeros*2);

        num_new_points = size_of(1)+num_zeros*2;
        
        % Adjuntamos nuestra matriz en todo el centro
        M_to_pad(1+num_zeros:num_zeros+size_of(1),1+num_zeros:num_zeros+size_of(2)) = M; 
            
        %Retornamos la matriz 

        M_padded = M_to_pad;


end

%% Funcion para hallar la transformada de Fourier Discreta DFT

function F_DFT = dft(z,lambda,U,V,X,Y,fun)
        
       size_of = size (fun);
       F_dft = zeros(size_of(1),size_of(2));
       for n = 1:1:size_of(1)
           for m = 1:1:size_of(2)
                ker = fun .* (exp(-1i*(2*pi/(lambda*z))*(U(:,m)*X(1,:)+Y(:,1)*V(n,:))))';
                F_dft(n,m) = sum(sum(ker));
           end
       end  

       F_DFT = F_dft;
end

%% Funcion para hallar la transformada de Fourier inversa Discreta
function f = idft(X,Y,U,V,FUN)
       
       size_of = size(FUN);
       f_idft = zeros(size_of(1),size_of(2));
       for n = 1:1:size_of(1)
           for m = 1:1:size_of(2)
                ker = FUN .* (exp(1i*2*pi*(X(:,m)*U(1,:)+V(:,1)*Y(n,:))))';
                f_idft(n,m) = sum(sum(ker));
           end
       end      
       
       f = f_idft;
end
  

%% Con esta funcion facilmente podemos cambiar el dominio ya creado durante la rutina
function [X,Y] = change_space_domain(dx,dy,new_points_x,new_points_y)
        x = linspace(0,dx*new_points_x,new_points_x);
        y = linspace(0,dy*new_points_y,new_points_y);
            
        [X,Y] = meshgrid(x,y);

end


%% Con esta funcion cambiamos el dominio espectrar

function [U,V] = change_spectral_domain(dfx,dfy,new_points_x,new_points_y)

            u = linspace(0,dfx*new_points_x,new_points_x);
            v = linspace(0,dfy*new_points_y,new_points_y);
                
           [U,V] = meshgrid(u,v);
end

%% Con esta funcion facilmente se puede cambiar los parametros espectrales

function [dfx,dfy] = change_frequencial_parameters(dx,dy,new_points_x,new_points_y)
        
        dfx = 1/(new_points_x *dx);
        dfy = 1/(new_points_y *dy);

end