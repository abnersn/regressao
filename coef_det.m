function [ result, result_adj ] = coef_det( X, y, coeffs )
%R2 Calcula o coeficiente de determina��o para uma s�rie de dados e os
%coeficientes de uma regress�o m�ltipla.

prediction = X * coeffs;

RSS = sum((y - prediction) .^ 2);
TSS = sum((y - mean(y)) .^ 2);

result = 1 - RSS / TSS;
n = length(y);
k = size(X, 2); 
result_adj = 1 - (RSS / (n - k)) / (TSS / (n - 1));

end

