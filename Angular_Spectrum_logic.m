%%%%%%%%%%%% IMPLEMENTACION DE EL METODO DE ESPECTRO %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%     ANGULAR POR DFT      %%%%%%%%%%%%%%%%%%%%%%%%%%%


%% ELEMENTOS 
%  -- La transformada de Fourier del campo de entrada, A(alfa/lambda,beta/lambda, 0)
%  -- Shiftear
%  -- Multiplicar la transformada por la funcion de transferencia del
%  espectro de llegada. A(alfa/lambda,beta/lambda, z)
%  -- Hallar la transformada inversa del espectro de llegada
%  --Shiftear
%   
%   Para ello definir :
%   - distancia z a la cual se quiere hallar la difraccion
%   - la longitud de onda
%   - longitud de muestreo
%   - numero de muestras, en este caso la cantidad de muestras debe de ser .
%   

% Vamos a suponer una ventana cuadrada por donde pasara una onda plana
% monocromatica , la luz chocara con la apertura rectangular de 1 m X 1 m
% con una longitud de onda de 600nm 

%Parametros
lambda = 600E-9;
longitud = 1; %% Longitud en metros
apertura = 1/2;
z = 10000; %Distancia de propagacion entre planos (m)

%% funcion rectangulo, el cual sera nuestro campo optico de entrada con aplitud igual a 1
rect2d = @(a,b) ( (( (longitud-apertura)/2 <= a) & (a <= (longitud+apertura)/2 )) & ...
                  (( (longitud-apertura)/2 <= b) & (b <= (longitud+apertura)/2 ))  );
num_of_points = 20; % Como la funcion rect no tiene limite en F_FFT_obanda entonces irse al limite de Nyquist no es util
                      % por lo que simplemente definimos muchas muestras en
                      % nuestra implementación


 
%% Los espaciamientos en x y en y definiran que tan buena sera la recontruccion 
%%de mi señal sin aliasing en el limite de Nyquisy se tiene que 

%%%%%%%%%%%%%%    delta_x =  longitud/numero de puntos;
%%%%%%%%%%%%%%    delta_y =  longitud/numero de puntos;

dx = longitud/num_of_points;  %% Modificando esto podemos obtener la imagen como tal sin
dy = longitud/num_of_points;  %% Perdida de información
dfx = 1/((num_of_points)* dx); %% steps en x del plano espectral Para un espaciamiento en limite de Nyquist
dfy = 1/((num_of_points)* dy); %% Steps en y del plano espectral

x = linspace(0,longitud,num_of_points);
y = linspace(0,longitud,num_of_points);

u = linspace(0,num_of_points*dfx , num_of_points);
v = linspace(0,num_of_points*dfy , num_of_points);

% Creamos vectores de datos X, Y donde se va a contener cada valor de la maya 
[X,Y] = meshgrid(x,y);
[U,V] = meshgrid(u,v);

% Definimos la funcion f como el campo optico que se propagara y se
% difractará
f = rect2d(X,Y);

%%Aumentamos la campo optico de entrada con zeros para mejorar la separacion de clones
f = padding(f,50);

size_f = size(f);

%Cambiamos los parametros de salto entre puntos si es necesario, para el
%caso de un padding, queremos cambiar la cantidad de muestras para
%disminuir el espaciamiento entre muestras en el espectro

disp(dfx);
disp(dx);

[dfx,dfy] = change_frequencial_parameters(dx,dy,size_f(1),size_f(2));

disp(dfx);
disp(dx);

%Aumentamos tambien los dominios 
[X,Y] = change_space_domain(dx,dy,size_f(1),size_f(2));
[U,V] = change_spectral_domain(dfx,dfy,size_f(1),size_f(2));

num_of_points = size_f(1);


%% Implementacion por FFT

% Sacamos la transformada de Fourier del campo de entrada para conocer el
% espectro angular del mismo
F_FFT_o = fft2(f);
%F_FFT_o = fftshift(F_FFT_o);
F_FFT_o = F_FFT_o./(max(max(abs(F_FFT_o))));
%F_FFT_o = abs(F_FFT_o);


figure;
subplot(2,2,1);
imagesc(f);
title("Campo de entrada |f| (FFT)")

% El siguiente paso es multiplicar el espectro angular de entrada por la 
% funcion de transferencia del espacio libre para asi obtener el espectro
% angular del campo óptico de llegada posterior a la difracción

F_FFT_s = F_FFT_o .* exp(1i * z * sqrt((2*pi/lambda)^2-(U*2*pi).^2-(V*2*pi).^2));

% Ahora el último paso será sacar la transformada de fourier inversa
% discreta al espectro angular del campo optico de llegada


f_fft_reconstructed = ifft2(F_FFT_s); %% Shifteamos ya que ifft2 
                                                % ya tiene la funcion de hacer el shift por dentro 

%% Ya con esto se habra logrado implementar el espectro angular de forma discreta

% subplot(2,2,3)
% imagesc(abs(f_fft_reconstructed));
% title("Campo Difractado |F| (FFT)")


subplot(2,2,3)
imagesc(abs(F_FFT_o));
title("Campo Espectral de entrada |F| (FFT)")

%% Implementacion de la DFT.

%%Hallamos la transformada de Fourier del espectro de entrada

%Implementacion por DTF

F_DFT_o =  dft(U,V,X,Y,f);

%F_DFT_o = shift(F_DFT_o);
F_DFT_o = F_DFT_o./(max(max(abs(F_DFT_o))));
%F_DFT_o = abs(F_DFT_o);


subplot(2,2,2)
imagesc(f);
title("Campo de Entrada |f| (DFT)")

f_dft_reconstructed = zeros(num_of_points,num_of_points);

F_DFT_s = F_DFT_o .* exp(1i * z * 2*pi*sqrt((1/lambda)^2-(U).^2-(V).^2));

for p = 1:1:num_of_points
    for q = 1:1:num_of_points
        for n= 1:1:num_of_points
            for m = 1:1:num_of_points    

                f_dft_reconstructed(p,q) = f_dft_reconstructed(p,q) + ... 
                                              F_DFT_s(n,m).*exp(1i*2*pi*(X(p,q).*U(n,m)+Y(p,q).*V(n,m)));

            end
        end
    end
end

% subplot(2,2,4)
% imagesc(abs(f_dft_reconstructed));
% title("Campo Difractado |F| (DFT)")

subplot(2,2,4)
imagesc(abs(F_DFT_o));
title("Campo Espectral de Entrada |F| (DFT)")


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

%% Funcion para hallar la transformada de fourier Discreta DFT

function F_DFT = dft(U,V,X,Y,fun)
       
       size_of = size(fun);
       F_dft = zeros(size_of(1),size_of(2));

       for p = 1:1:size_of(1)
            for q = 1:1:size_of(2)
                for n= 1:1:size_of(1)
                    for m = 1:1:size_of(2)    
                        F_dft(p,q) = F_dft(p,q) + fun(n,m) * exp(-1i*2*pi*(U(p,p)*X(n,n) + V(q,q)*Y(m,m)));
                    end
                end
            end
       end

       F_DFT = F_dft;
        
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