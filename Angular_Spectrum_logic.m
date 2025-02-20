%%%%%%%%%%%% IMPLEMENTACION DE EL METODO DE ESPECTRO %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%     ANGULAR POR DFT  (PUNTO 2)    %%%%%%%%%%%%%%%%%%%%%%%%%%%


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
longitud = 1E-4; %% Longitud en metros
apertura = longitud/10;

z = 1;

%% funcion rectangulo, el cual sera nuestro campo optico de entrada con aplitud igual a 1
rect2d = @(a,b) ( (( (longitud-apertura)/2 <= a) & (a <= (longitud+apertura)/2 )) & ...
                 (( (longitud-apertura)/2 <= b) & (b <= (longitud+apertura)/2 ))  );
num_of_points = 150; % Como la funcion rect no tiene limite en F_FFT_obanda entonces irse al limite de Nyquist no es util
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

x = linspace(0,(num_of_points-1)*dx,num_of_points);
y = linspace(0,(num_of_points-1)*dy,num_of_points);

u = linspace(0,(num_of_points-1)*dfx , num_of_points);
v = linspace(0,(num_of_points-1)*dfy , num_of_points);

% Creamos vectores de datos X, Y donde se va a contener cada valor de la maya 
[X,Y] = meshgrid(x,y);
[U,V] = meshgrid(u,v);

% Definimos la funcion f como el campo optico que se propagara y se
% difractará
f = rect2d(X,Y);

figure;
%% Implementacion por FFT

% Sacamos la transformada de Fourier del campo de entrada para conocer el
% espectro angular del mismo
F_FFT_o = fft2(f);
F_FFT_o = shift(F_FFT_o);

subplot(2,2,1);
imagesc(f);
title("Campo de entrada |f| (FFT)")

% El siguiente paso es multiplicar el espectro angular de entrada por la 
% funcion de transferencia del espacio libre para asi obtener el espectro
% angular del campo óptico de llegada posterior a la difracción

F_FFT_s = F_FFT_o .* exp(1i * z * sqrt((2*pi/lambda)^2-((U-(num_of_points*dfx)/2)*2*pi).^2 ...
                                                      -((V-(num_of_points*dfy)/2)*2*pi).^2));

% Ahora el último paso será sacar la transformada de fourier inversa
% discreta al espectro angular del campo optico de llegada


f_fft_reconstructed = ifft2(F_FFT_s); %% Shifteamos ya que ifft2 
                                                % ya tiene la funcion de hacer el shift por dentro 

%% Ya con esto se habra logrado implementar el espectro angular de forma discreta

subplot(2,2,3)
imagesc(abs(f_fft_reconstructed));
title("Campo Difractado |F| (FFT)")


%% Implementacion de la DFT.

% %%Hallamos la transformada de Fourier del espectro de entrada
% 
% %Implementacion por DTF
% 
% F_DFT_o =  dft(U,V,X,Y,f);
% 
% F_DFT_o = shift(F_DFT_o);
% 
% 
% subplot(2,2,2)
% imagesc(f);
% title("Campo de Entrada |f| (DFT)")
% 
% F_DFT_s = F_DFT_o .* exp(1i * z * 2*pi*sqrt((1/lambda)^2-(U-(num_of_points*dfx)/2).^2-(V- (num_of_points*dfy)/2).^2));
% 
% f_dft_reconstructed = idft(X,Y,U,V,F_DFT_s);
% 
% subplot(2,2,4)
% imagesc(abs(f_dft_reconstructed));
% title("Campo Difractado |F| (DFT)")


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

%% Funcion para hallar la transformada de Fourier Discreta DFT

function F_DFT = dft(U,V,X,Y,fun)
        
       size_of = size (fun);
       F_dft = zeros(size_of(1),size_of(2));
       for n = 1:1:size_of(1)
           for m = 1:1:size_of(2)
                ker = fun .* (exp(-1i*2*pi*(U(:,m)*X(1,:)+Y(:,1)*V(n,:))))';
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