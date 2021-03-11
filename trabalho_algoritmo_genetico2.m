1;
clear
clc


GERACOES = 1000;
QTDE_POPULACAO = 10;
TAXA_MUTACAO = 0.1;


function reval = fitness(cromo)
  soma = 0;
  for i =  1:length(cromo)
      soma = soma + cromo(i);
  endfor
  reval = soma;
endfunction

function reval = mutacao(cromo)
  cromo = cromo.cromo;
  for i =  1:length(cromo)
      if deve_mutacionar()
        cromo(i) = rand(1, 1);
      endif
  endfor
  y.cromo = cromo;
  y.fitness = fitness(cromo);
  reval = y;
endfunction;

function reval = deve_mutacionar()
  global TAXA_MUTACAO
  aleatorio = rand(1, 1);
  if aleatorio < TAXA_MUTACAO
    reval = true;
  else
    reval = false;
  endif
endfunction

function reval = cross_over(cromo1, cromo2)
  cromo3 = zeros(1, 5);
  
  for i =  1:length(cromo1)
    aleatorio = rand(1, 1);
    if aleatorio > 0.5
      cromo3(i) = cromo1(i);
    else
      cromo3(i) = cromo2(i);
    endif
  endfor
  y.cromo = cromo3;
  y.fitness = fitness(cromo3);
  reval = y;
endfunction

function y = gerar_cromo()
    y.cromo = rand(1, 5);
    y.fitness = fitness(y.cromo);
endfunction

function y = gerar_populacao_com_fitness(qtde_populacao)
  t(1, qtde_populacao) = struct();

  for i = 1:length(t)
    t(i) = gerar_cromo();
  endfor
  y = t;
endfunction

function y = escolher_melhor_cromo(populacao)
  melhores_cromos = criar_estrutura_cromo(2);

  for i = 1:length(populacao)
    fitness = populacao(i).fitness;
    cromo = populacao(i).cromo;
    if fitness > melhores_cromos(1).fitness
      melhores_cromos(1).fitness = fitness;
      melhores_cromos(1).cromo = cromo;
      continue;
    endif
    if fitness > melhores_cromos(2).fitness
      melhores_cromos(2).fitness = fitness;
      melhores_cromos(2).cromo = cromo;
    endif
  endfor
  y = melhores_cromos;
endfunction

function y = criar_estrutura_cromo(tamanho_gene)
  cromos(1, tamanho_gene) = struct();
  for i = 1:length(cromos)
    cromos(i).fitness = 0;
    cromos(i).cromo = [];  
  endfor
  y = cromos;
endfunction

populacao = gerar_populacao_com_fitness(QTDE_POPULACAO);

for i = 1:GERACOES
  melhores_cromos = escolher_melhor_cromo(populacao);
  cromo_com_cross_over = cross_over(
    melhores_cromos(1).cromo, melhores_cromos(2).cromo
  );
  cromo_com_cross_over = mutacao(cromo_com_cross_over);
  cromo_com_cross_over.fitness
  populacao = gerar_populacao_com_fitness(QTDE_POPULACAO - 1);
  populacao(end+1) = cromo_com_cross_over;
  populacao;
endfor











