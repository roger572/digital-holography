% com = norm_COM(set_im,colores)
%
% size(set_im) = [filas columnas tiempo]
% colores: cantidad de colores

function com = norm_COM(set_im,colores)

norm_COM = zeros(colores);
mm = min(set_im(:));
if mm <= 0
	set_im = set_im - mm + 1;
end
    
for k = 2:size(set_im,3)
    for l = 1:size(set_im,1)
        for m = 1:size(set_im,2)
            norm_COM (set_im(l,m,k-1),set_im(l,m,k)) = norm_COM (set_im(l,m,k-1),set_im(l,m,k)) + 1;
        end
    end
end
divisores = sum(norm_COM,2);
divisores(divisores==0) = 1;
com = norm_COM ./ repmat(divisores,1,colores);