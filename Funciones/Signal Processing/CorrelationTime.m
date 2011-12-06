% tc = CorrelationTime(X)
% Se ingresa una matriz con se�ales en sus filas y se encuentra el tiempo
% de correlaci�n a 1/e del grado complejo de coherencia en cada una de las
% se�ales.

function tc = CorrelationTime(X)

e = 1/exp(1);
e2 = e^2;
tc = zeros(size(X,1),1);


% %% Considerando que es directamente u(t)
% for k = 1:size(X,1)
%     correl = xcorr(X(k,:)-mean(X(k,:)),'unbiased');
%     correl = correl / correl(size(X,2));
%     correl = correl(size(X,2):end);
%     correl = correl < e;
%     correl = cumsum(correl);
%     tc(k) = sum(correl == 0);
% end

%%% Considerando que es G_I(tau) lo que se obtiene de hacer la correlaci�n,
%%% si g(tc) = 1/e, G_I(tau) = I^2(1+|g(tau)|^2), G_I(tc)normalizado =
%%% (1+|g(tc)|^2)/2 = (1+1/e^2)/2
lim = (1+e2)/2;

for k = 1:size(X,1)
%     correl = xcorr(X(k,:)-mean(X(k,:)),'unbiased');
    correl = xcorr(X(k,:),'unbiased');
    correl = correl / correl(size(X,2));
    plot(correl)
    correl = correl(size(X,2):end);
    % Me quedo con la parte descendente
%     tc(k) = interp1q(correl,0:(length(correl)-1),lim);

%     correl = correl < lim;
%     correl = cumsum(correl);
%     tc(k) = sum(correl == 0);
end