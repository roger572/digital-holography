% Funcion para generar los archivos .dat en columnas
% ACol(CarpetaOrigen,CarpetaDestino,L,N,L2,extension)

function ACol(CarpetaOrigen,CarpetaDestino,L,N,L2,extension)

if CarpetaOrigen(end) == '\'
    carpetaorigen = CarpetaOrigen(1:end-1); % Le saco el \ del final
else
    carpetaorigen = CarpetaOrigen;
end
if CarpetaDestino(end) ~= '\'
    CarpetaDestino = [CarpetaDestino '\'];
end

if nargin <6
    extension = 'tif';
end
if nargin < 5
    resol = [L L];
else
    resol = [L L2];
end
bloques = 1;
imxbloque = N;
paso = floor(N/8);
columna = 1:resol(2);

for k_arch = 1:paso:bloques*imxbloque
    k_arch_prox = k_arch + paso - 1;
    thsp = THSP_col(carpetaorigen,extension,resol,columna,k_arch,k_arch_prox);
    for k_newarch = 1:resol(2)
        nombre_arch = [CarpetaDestino 'columna0000'];
        numero = num2str(k_newarch);
        nombre_arch(( end - length(numero)+1 ):end) = numero;
        nombre_arch = [nombre_arch '.dat'];
        im_agregada = permute(thsp(:,k_newarch,:),[1 3 2]);
        fid = fopen(nombre_arch,'a');
        fwrite(fid,im_agregada,'uchar'); % Si no est� normalizado se usa 'uchar', pero si est� normalizado se usa 'float32'
        fclose(fid);
    end
end