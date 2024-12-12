%%%%%%%%%%%%%%% Determinacion de la imagen difractada una %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%    cierta distancia     %%%%%%%%%%%%%%%%%%%%%%%%%


%% Primero definimos todos los parametros de la forma de la luz usada para la difracción

lambda = 633E-9;
dx = 3.45E-6;
dy = 3.45E-6;

z = 0.14578;

num_of_points = 2048;

dfx = 1/((num_of_points)*dx);
dfy = 1/((num_of_points)*dy);

u = linspace(0,(num_of_points-1)*dfx,num_of_points);
v = linspace(0,(num_of_points-1)*dfy,num_of_points);

[U,V] = meshgrid(u,v);

im = double(imread('C:\Users\JUAN ESTEBAN\Desktop\Imag.png'));
re = double(imread('C:\Users\JUAN ESTEBAN\Desktop\Real.png'));
inten = double(imread('C:\Users\JUAN ESTEBAN\Desktop\Intensity.png'));

f_opt = (re + 1i*im) ;
f_int = inten;


f_opt_fft = fft2(f_opt);
f_int_fft = fft2(f_int);

f_opt_fft = shift(f_opt_fft);
f_int_fft = shift(f_int_fft);

f_opt_prop = f_opt_fft .* exp(-1i*z*(2*pi)*sqrt((1/lambda)^2-(U-(num_of_points*dfx)/2).^2-(V-(num_of_points*dfy)/2).^2));
f_int_prop = f_int_fft .* exp(-1i*z*(2*pi)*sqrt((1/lambda)^2-(U-(num_of_points*dfx)/2).^2-(V-(num_of_points*dfy)/2).^2));

f_opt_reconstructed = ifft2(f_opt_prop);
f_int_reconstructed = ifft2(f_int_prop);

figure;
subplot(2,2,1);
imagesc(abs(f_opt));
title('Amplitud y fase difractado');

subplot(2,2,3);
imagesc(abs(f_opt_reconstructed));
title('Imagen recuperada desde su amplitud y fase');

subplot(2,2,2);
imagesc(abs(f_int));
title('Amplitud difractada');

subplot(2,2,4);
imagesc(abs(f_int_reconstructed));
title('Imagen recuperada solo con la amplitud');


colormap('gray');



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


