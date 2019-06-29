% UNIVERSIDADE FEDERAL DO CEARÁ
% ENGENHARIA DA COMPUTAÇÃO
% ABNER SOUSA NASCIMENTO

% TÓPICOS EM SISTEMAS DE COMUNICAÇÕES MÓVEIS 2019.1

% TRABALHO 4 - REGRESSÃO LINEAR MÚLTIPLA

close all; clear all; clc;

% Base de dados utilizada: Global Climate Change Data. Dados de medições da
% temperatura global de 1850 até 2015. A base contém as seguintes
% informações:
% - LandAverageTemperature (Y)
%     Média de todas as temperaturas registradas.
% - LandMaxTemperature (X1)
%     Média de todas as máximas registradas.
% - Year (X4)
%     Ano das mediçãoes.
% Observação: A base original lista os registros mês a mês para medir as
% flutuações sazonais, porém, para este trabalho, foi utilizado o total
% médio de cada ano.

% Objetivo 1: Modelar a temperatura média global com base no ano e na
% temperatura máxima.

table = readtable('temperaturas.csv');
X = table{:, {'LandMaxTemperature', 'Year'}};
y = table{:, {'LandAverageTemperature'}};

figure;
scatter3(table.LandMaxTemperature, table.Year,...
    table.LandAverageTemperature, 'x', 'red');
xlabel('Máxima anual');
ylabel('Ano');
zlabel('Temperatura média');
hold on;

% Regressão múltipla com todas as variáveis
X = [ones(length(X), 1) X];
beta = inv(X'*X)*X'*y;
[r2, r2_adj] = coef_det(X, y, beta);

[x1, x2] = meshgrid(16:.2:23, 1850:15:2015);
s = surf(x1, x2, beta(1) + beta(2) * x1 + beta(3) * x2);
s.EdgeColor = [0.2 0.6 0.8] * 0.7;
s.FaceColor = [0.2 0.6 0.8];
title({'Regressão Múltipla', sprintf('R2: %.3f, R2 ajustada: %.3f', r2, r2_adj)});

% Regressões individuais com cada variável
figure;
X(:, 1) = []; % Remove coluna de 1s
x_labels = {'Máxima anual', 'Ano'};
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
    ylabel('Temperatura média');
    [r2, r2_adj] = coef_det([ones(length(x), 1) x], y, [a; b]);
    title({x_labels{i}, sprintf('R2: %.3f, R2 ajustada: %.3f', r2, r2_adj)});
end

