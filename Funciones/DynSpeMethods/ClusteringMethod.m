function Im = ClusteringMethod(Ejs,tamQuad,method,Clusters)

% Si hay una 4D esa es la que tiene los datos, para tratarla se pasa a la
% 3era.
if size(Ejs,4) > 1
    Ejs = permute(Ejs,[1 2 4 3]);
end
s_Ejs = size(Ejs);
if length(s_Ejs)==3
    s_Ejs(4) = 1;
end
if length(s_Ejs) == 2
    s_Ejs(3) = 1;
end
dimF = s_Ejs(3);

% Simple correcci�n de errores en Ejs, copio el pixel de arriba de donde
% hay un NaN
while sum(isnan(Ejs(:))) > 0
    Ejs(isnan(Ejs)) = Ejs(circshift(isnan(Ejs),1));
end


% Normalizaci�n, se pierden datos pero para este an�lisis no es importante,
% para analizar espectro de Legendre s� ser�a importante.
X = AVectorFiltFull(Ejs,tamQuad,'@chebwin');
Ejs(:) = X./repmat(sum(X,2),1,dimF);

% Ejs = Ejs ./ repmat(sum(Ejs,3),[1 1 s_Ejs(3) 1]);
% 
Ejs = log10(Ejs); % Si se usa wenergy habr�a que dividir por 100 a Ejs
% Se corrigen los log10(0)
maximodetodos = max(Ejs(:));
for k=1:size(Ejs,3)
    correcciones = find((Ejs(:,:,k) < -30)|isinf(Ejs(:,:,k))|isnan(Ejs(:,:,k)));
    correcciones = correcciones + s_Ejs(1)*s_Ejs(2)*(k-1);
    Ejs(correcciones) = maximodetodos;
    if length(correcciones)
        Ejs(correcciones) = min(min(Ejs(:,:,k)));
    end
end

% Clustering
if strcmp(method,'KMeans')
    [Im C ClustersFin] = ClusteringFiltFull(Ejs,tamQuad,Clusters,0,0);
elseif strcmp(method,'FCM')
    [Im C ClustersFin] = ClusteringFiltFull(Ejs,tamQuad,Clusters,0,1);
elseif strcmp(method,'EM')
    [Im C ClustersFin] = ClusteringFiltFull(Ejs,1,Clusters,0,2);
elseif strcmp(method,'MEM')
    [Im C ClustersFin] = ClusteringFiltFull(Ejs,tamQuad,Clusters,0,3);
elseif strcmp(method,'CNN')
    [Im C ClustersFin] = CompetNNFull(Ejs,tamQuad,Clusters,0,50);
elseif strcmp(method,'SOM')
    [Im C ClustersFin] = SOMFull(Ejs,tamQuad,Clusters,0,50);
end

% Se multiplica por -1 a los n�meros negativos de energ�a relativa en dBs y
% luego se escala para que sumen 1 para poder calcular la entrop�a
C_ord = -C;
C_ord = C_ord./repmat(sum(C_ord,2),1,dimF);
fC = zeros(ClustersFin,1);
for k_cluster = 1:ClustersFin
    mayoresQcero = C_ord(k_cluster,find(C_ord(k_cluster,:)>0));
    fC(k_cluster) = -sum(mayoresQcero.*log2(mayoresQcero),2);
end

Im = fC(Im);