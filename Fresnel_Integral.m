%%%%%%%%%%%% IMPLEMENTACIÓN DE LA INTEGRAL DE FRESNEL %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%          POR FFT y DFT   (PUNTO 2)      %%%%%%%%%%%%%%%%%%%%%%%%%%%


%% ELEMENTOS 
%  -- La transformada de Fourier del campo de entrada, multiplicada la fase
%  parabolica de la apertura
%  -- Shiftear
%  -- Multiplicar la transformada por la fase parabolica del plano de
%  llegada y la forma de la onda esferica divergente dependiente de z
%  --Shiftear
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
longitud = 1; %% Longitud en metros
apertura = longitud/10;
z = 10000;


%% funcion rectangulo, el cual sera nuestro campo optico de entrada con aplitud igual a 1
rect2d = @(a,b) ( (( (longitud-apertura)/2 <= a) & (a <= (longitud+apertura)/2 )) & ...
                 (( (longitud-apertura)/2 <= b) & (b <= (longitud+apertura)/2 ))  );
num_of_points = 150; % Como la funcion rect no tiene limite en F_FFT_obanda entonces irse al limite de Nyquist no es util
                      % por lo que simplemente definimos muchas muestras en
                      % nuestra implementación


 
%% Los espaciamientos en x y en y definiran que tan buena sera la recontruccion 
%%de mi señal sin aliasing en el limite de Nyquisy se tiene que 


dx = longitud/num_of_points;  %% Modificando esto podemos obtener la imagen como tal sin
dy = longitud/num_of_points;  %% Perdida de información
dxo = (lambda*z)/(num_of_points* dx); %% steps en x del plano espacial difractado Para un espaciamiento en limite de Nyquist
dyo = (lambda*z)/(num_of_points* dy); %% Steps en y del plano espacial difractado

x = linspace(0,(num_of_points-1)*dx,num_of_points);
y = linspace(0,(num_of_points-1)*dy,num_of_points);

xo = linspace(0,(num_of_points-1)*dxo , num_of_points);
yo = linspace(0,(num_of_points-1)*dyo , num_of_points);

% Creamos vectores de datos X, Y donde se va a contener cada valor de la maya 
[X,Y] = meshgrid(x,y);
[XO,YO] = meshgrid(xo,yo);


figure;

% Definimos la funcion f como el campo optico que se propagara y se
% difractará
f = rect2d(X,Y);

subplot(2,1,1);
imagesc(f);
title("Campo de entrada |f| (FFT)");


%% Implementacion por FFT

% Sacamos la transformada de Fourier del campo de entrada multiplicada por
% la fase parabolica de entrada en la apertura
f_fft_o = fft2(f.* exp(1i*(pi/(lambda*z))*((X-(num_of_points*dx)/2).^2 + ...
                                           (Y-(num_of_points*dy)/2).^2)));
f_fft_o = shift(f_fft_o);




% El siguiente paso es multiplicar el espectro angular de entrada por la 
% función de transferencia del espacio libre para así obtener el espectro
% angular del campo óptico de llegada posterior a la difracción

f_fft_s = f_fft_o .* exp(1i*(pi/(lambda*z)) * ((XO-(num_of_points*dxo)/2).^2 + ...
                                               (YO-(num_of_points*dyo)/2).^2))*exp(1i*(2*pi/lambda)*z)*(-1i/(lambda*z));

subplot(2,1,2);
imagesc(abs(f_fft_s));
title("Campo Difractado |f| (FFT)")


%% Implementacion por DFT

% f_DFT_o = dft(z,lambda,X,Y,XO,YO,f.* exp(1i*(pi/(lambda*z))*((X-(num_of_points * dx)/2).^2 + (Y-(num_of_points * dy)/2).^2)));
% f_DFT_o = shift(f_DFT_o);
% f_DFT_s = f_DFT_o .* exp(1i*(pi/(lambda*z)) * ((XO-(num_of_points*dxo)/2).^2 + ...
%                                                (YO-(num_of_points*dyo)/2).^2))*exp(1i*(2*pi/lambda)*z)*(-1i/(lambda*z));
% 
% 
% subplot(2,1,2);
% imagesc(abs(f_DFT_s));
% title("Campo Difractado |f| (DFT)")
                                           
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


