% UNIVERSIDADE FEDERAL DO CEAR�
% ENGENHARIA DA COMPUTA��O
% ABNER SOUSA NASCIMENTO

% T�PICOS EM SISTEMAS DE COMUNICA��ES M�VEIS 2019.1

% TRABALHO 4 - REGRESS�O LINEAR M�LTIPLA

close all; clear all; clc;

% Base de dados utilizada: Global Climate Change Data. Dados de medi��es da
% temperatura global de 1850 at� 2015. A base cont�m as seguintes
% informa��es:
% - LandAverageTemperature (Y)
%     M�dia de todas as temperaturas registradas.
% - LandMaxTemperature (X1)
%     M�dia de todas as m�ximas registradas.
% - Year (X4)
%     Ano das medi��oes.
% Observa��o: A base original lista os registros m�s a m�s para medir as
% flutua��es sazonais, por�m, para este trabalho, foi utilizado o total
% m�dio de cada ano.

% Objetivo 1: Modelar a temperatura m�dia global com base no ano e na
% temperatura m�xima.

table = readtable('temperaturas.csv');
X = table{:, {'LandMaxTemperature', 'Year'}};
y = table{:, {'LandAverageTemperature'}};

figure;
scatter3(table.LandMaxTemperature, table.Year,...
    table.LandAverageTemperature, 'x', 'red');
xlabel('M�xima anual');
ylabel('Ano');
zlabel('Temperatura m�dia');
hold on;

% Regress�o m�ltipla com todas as vari�veis
X = [ones(length(X), 1) X];
beta = inv(X'*X)*X'*y;
[r2, r2_adj] = coef_det(X, y, beta);

[x1, x2] = meshgrid(16:.2:23, 1850:15:2015);
s = surf(x1, x2, beta(1) + beta(2) * x1 + beta(3) * x2);
s.EdgeColor = [0.2 0.6 0.8] * 0.7;
s.FaceColor = [0.2 0.6 0.8];
title({'Regress�o M�ltipla', sprintf('R2: %.3f, R2 ajustada: %.3f', r2, r2_adj)});

% Regress�es individuais com cada vari�vel
figure;
X(:, 1) = []; % Remove coluna de 1s
x_labels = {'M�xima anual', 'Ano'};
for i=1:size(X, 2)
    x = X(:, i);
    b = sum((x - mean(x)) .* (y - mean(y))) / sum((x - mean(x)) .^ 2);
    a = mean(y) - b * mean(x);
    subplot(1, size(X, 2), i);
    scatter(x, y);
    hold on;
    plot(x, b * x + a, 'red');
    xlabel(x_labels(i));
    xlim([min(x), max(x)]);
    ylabel('Temperatura m�dia');
    [r2, r2_adj] = coef_det([ones(length(x), 1) x], y, [a; b]);
    title({x_labels{i}, sprintf('R2: %.3f, R2 ajustada: %.3f', r2, r2_adj)});
end

