% Hacer una DWT2 a un THSP y sacar la energ�a, o varianza de cada fila a
% distintas escalas.
% Dar la opci�n de usar una SWT2, perdiendo informaci�n de lo que pasa en
% los bordes.


% Creo que puede llegar a convenir tomar tiempos m�s cortos para el
% an�lisis. A lo mejor se puedan usar varias estimaciones de la actividad
% para usar m�s muestras.

function Ejs = WaveletEnergies2D(CarpetaMCol,L,N,madreWav,escalas)

extension = 'dat';
resol = [L L];
imagenes = N;
if nargin == 4
    cant_escalas = wmaxlev(min(imagenes,L),madreWav)+1;
else
    cant_escalas = escalas;
end
Ejs = zeros([resol cant_escalas*3]);

for k_col = 1:resol(2)
    thsp = obtener_columna(CarpetaMCol,resol,imagenes,k_col,'uchar');
    
    % Wavelet 2D
    [C S] = wavedec2(thsp,cant_escalas,madreWav);
    
    % Para cada escala se calcula la energ�a y se ubica donde corresponde
    for k_escala = 1:cant_escalas
        % Horizontales
        D = detcoef2('h',C,S,k_escala);
        D = sum(D.^2,2);
        D = D';
        D = repmat(D,L/length(D),1);
        Ejs(:,k_col,(k_escala-1)*3+1) = D(:);
        % Verticales
        D = detcoef2('v',C,S,k_escala);
        D = sum(D.^2,2);        
        D = D';
        D = repmat(D,L/length(D),1);
        Ejs(:,k_col,(k_escala-1)*3+2) = D(:);                  
        % Diagonales
        D = detcoef2('d',C,S,k_escala);
        D = sum(D.^2,2);  
        D = D';
        D = repmat(D,L/length(D),1);
        Ejs(:,k_col,(k_escala-1)*3+3) = D(:);             
    end       
end

% Relativizar energ�as
Etotales = sum(Ejs,3);
Ejs = Ejs./repmat(Etotales,[1 1 cant_escalas*3]);