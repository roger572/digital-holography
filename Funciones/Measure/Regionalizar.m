% [Reg contR] = Regionalizar(A,listA)
%
%   Función que toma una imagen segmentada y la regionaliza asignando a
%   cada región un número.

function [Reg contR] = Regionalizar(A)

sA = size(A);
Reg = zeros(sA);
contR = 1;
Reg(1) = 1;

% Tratamiento de la primer fila
k = 1;
for m = 2:sA(2)
    if A(k,m) == A(k,m-1)
        Reg(k,m) = Reg(k,m-1);
    else
        contR = contR + 1;
        Reg(k,m) = contR;
    end
end
% Resto de la imagen
for k = 2:sA(1)
    % primero de la fila
    if A(k,m) == A(k-1,m)
        Reg(k,m) = Reg(k-1,m);
    else
        contR = contR + 1;
        Reg(k,m) = contR;
    end
    % resto de la fila
    for m = 2:sA(2)
        if A(k,m) == A(k,m-1)
            Reg(k,m) = Reg(k,m-1);
        elseif A(k,m) == A(k-1,m)
            Reg(k,m) = Reg(k-1,m);
        elseif m < sA(2)
            if A(k,m) == A(k-1,m+1)
                Reg(k,m) = Reg(k-1,m+1);
            end
        else
            contR = contR + 1;
            Reg(k,m) = contR;
        end
    end
end