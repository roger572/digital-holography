% CC = coefcorr3(carpeta,extension)
%
% Funci�n que calcula el coeficiente de correlaci�n en una secuencia de
% im�genes que se encuentran en una "carpeta" y son de una "extensi�n".

function CC = coefcorr3(carpeta,extension,zona)

dir_in1 = strcat(carpeta,'\');
dir_in = strcat(dir_in1,'*.',extension);
direc = dir(dir_in);

CCs = zeros(length(direc)-1,1);

for k_arch = 1 : length(direc)
    archivo = strcat(dir_in1,direc(k_arch,1).name);
    if strcmp(extension,'dat')
        fid = fopen(archivo,'rb');
        [im,count] = fread(fid,resol,'uchar');
        fclose(fid);
    else
        im = imread(archivo);
    end
    if k_arch == 1
        im1 = im(zona);
    else
        CCs(k_arch-1) = corr2(im1,im(zona));
        im1 = im(zona);
    end
end

CC = mean(CCs);