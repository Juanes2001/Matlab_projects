%parametros
lambda = 633E-9;
num_points= 2048;
dx=3.45E-6;
dy=3.45E-6;
z=0.1;
%defino los ejes espacial y frecuencial con el numero de puntos y la
%separación exigida
dfx= 1/(num_points*dx);
dfy= 1/(num_points*dy);
x= linspace(0,(num_points-1)*dx,2048);
y= linspace(0,(num_points-1)*dy,2048); 
u=linspace(0,(num_points-1)*dfx,2048); 
v=linspace(0,(num_points-1)*dfy,2048); 

%defino la malla de las frecuencias
[U,V]=meshgrid(u,v);

%Leo la imagen real e imaginaria, las sumo y así tengo el campo difractivo
%en la salida
R=double(imread("C:\Users\juane\OneDrive\Desktop\Instrumentos Opticos_practicas\Practica_1\Real.png"));
I=double(imread("C:\Users\juane\OneDrive\Desktop\Instrumentos Opticos_practicas\Practica_1\Imag.png"));
Uout= R + 1i*I;

kernel = exp(-1i*z*(2*pi/lambda)* ...
    sqrt(1-(lambda*(U-(num_points*dfx)/2)).^2-(lambda*(V-(num_points*dfy)/2)).^2))  ;

%hallamos la transformada de fourirer del campo de salida

Fourier_Uout = fft2(Uout);
Fourier_Uout = shift(Fourier_Uout);

%multiplico el kernel por la imagen difractiva
Uout2= Fourier_Uout.*kernel;
%Finalmente transformada inversa
Uin = ifft2(Uout2);

%mostremos la imagen
figure;

subplot(2,1,1);
imagesc(abs(Uout));

subplot(2,1,2);
imagesc(abs(Uin));


colormap("gray");



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

