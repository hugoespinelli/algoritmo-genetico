1;
clear
clc

GERACOES = [20 40 80 100];
QTDE_POPULACAO = 36;
QTDE_INDIVIDUOS_SELECIONADOS = 9;
TAXA_MUTACAO = 0.01;
TAXA_CRUZAMENTO = 0.25;

function reval = funcao_a_ser_maximizada(x, y)
  reval = 100 * (y - x**2) + (y - 2)**2;
endfunction

function reval = fitness(cromo)
  f0 = funcao_a_ser_maximizada(cromo(1), cromo(2));
  reval = 1/f0;
endfunction

function reval = mutacao(populacao, TAXA_MUTACAO)
  x = 1;
  y = 2;
  for i = 1:length(populacao)
    houve_mutacao = false;

    # mutacion o cromo X
    if deve_mutacionar(TAXA_MUTACAO)
      populacao(i).cromo(x) = gerar_numero_no_espaco_de_busca();
      houve_mutacao = true;
    endif

    # mutaciona o cromo Y
    if deve_mutacionar(TAXA_MUTACAO)
      populacao(i).cromo(y) = gerar_numero_no_espaco_de_busca();
      houve_mutacao = true;
    endif

    if houve_mutacao
      populacao(i).fitness = fitness(populacao(i).cromo);
    endif

  endfor

  reval = populacao;
endfunction;

function reval = deve_mutacionar(TAXA_MUTACAO)
  aleatorio = randi([0, 100]) / 100;
  reval = aleatorio < TAXA_MUTACAO;
endfunction

function reval = deve_cruzar(TAXA_CRUZAMENTO)
  aleatorio = randi([0, 100]) / 100;
  reval = aleatorio < TAXA_CRUZAMENTO;
endfunction

function reval = gerar_numero_no_espaco_de_busca()
  reval = randi([-50, 50]) / 10; 
endfunction

function reval = gerar_cromo()
    x = gerar_numero_no_espaco_de_busca();
    y = gerar_numero_no_espaco_de_busca();
    reval = [x, y];
endfunction

function y = gerar_individuo()
  y.cromo = gerar_cromo();
  y.fitness = fitness(y.cromo);
endfunction

function y = gerar_populacao_com_fitness(qtde_populacao)
  t(1, qtde_populacao) = struct();

  for i = 1:length(t)
    t(i) = gerar_individuo();
  endfor
  
  y = t;
endfunction

function reval = selecao(populacao, qtde_individuos_selecionados)
  fitness_normalizado = fitness_normalizado(populacao);
  total_aptidao = sum(fitness_normalizado);
  individuo_escolhidos = [];
  for i = 1:qtde_individuos_selecionados
    indice_de_individuo_escolhido = girar_roleta(total_aptidao, fitness_normalizado);
    individuo_escolhidos = [individuo_escolhidos populacao(indice_de_individuo_escolhido)];
  endfor
  reval = individuo_escolhidos;
endfunction

function reval = girar_roleta(total_aptidao, fitness)
  i = 0;
  soma = 0;
  aleatorio = randi([1, 99]) / 100;
  while soma < aleatorio
    i = i + 1;
    aptidao = aptidao_relativa(fitness(i), total_aptidao);
    soma = soma + aptidao;
  endwhile
  reval = i;
endfunction

function reval = aptidao_relativa(aptidao, aptidao_total)
  reval = (aptidao / aptidao_total);
endfunction

function reval = normaliza(aptidoes)
  reval = aptidoes - min(aptidoes(:));
endfunction

function reval = fitness_normalizado(populacao)
  aptidoes = [];
  for i = 1:length(populacao) 
    aptidoes = [aptidoes populacao(i).fitness];
  endfor
  reval = normaliza(aptidoes);
endfunction

function reval = cruzamento(populacao, TAXA_CRUZAMENTO)
  x = 1;
  y = 2;

  for i = 1:length(populacao) - 1
    if deve_cruzar(TAXA_CRUZAMENTO)
      temp = populacao(i+1).cromo(x);
      populacao(i+1).cromo(x) = populacao(i).cromo(x); 
      populacao(i).cromo(x) = temp;

      populacao(i).fitness = fitness(populacao(i).cromo);
      populacao(i+1).fitness = fitness(populacao(i+1).cromo);
    endif
  endfor

  reval = populacao;
endfunction

function reval = selecionar_melhor_individuo(populacao)
  aptidoes = [];

  for i = 1:length(populacao) 
    aptidoes = [aptidoes populacao(i).fitness];
  endfor

  [_, ix] = max(aptidoes);
  reval = populacao(ix);
endfunction

aptidoes = [];
for i = 1:length(GERACOES) 
  populacao = gerar_populacao_com_fitness(QTDE_POPULACAO);
  
  for j = 1:GERACOES(i) 
    individuos_escolhidos = selecao(populacao, QTDE_INDIVIDUOS_SELECIONADOS);
    individuos_escolhidos = cruzamento(individuos_escolhidos, TAXA_CRUZAMENTO);
    individuos_escolhidos = mutacao(individuos_escolhidos, TAXA_MUTACAO);
    populacao = [individuos_escolhidos gerar_populacao_com_fitness(QTDE_POPULACAO - length(individuos_escolhidos))];
  endfor

  melhor_individuo = selecionar_melhor_individuo(populacao);
  aptidoes = [aptidoes melhor_individuo.fitness];

  display('Valor minimo da funcao de 100 * (y - x**2) + (y - 2)**2 e: ');
  printf('Parametro mais otimizado da funcao e x:%d, y:%d . N de geracoes:%d \n', melhor_individuo.cromo(1), melhor_individuo.cromo(2), GERACOES(i));

endfor

plot(GERACOES, aptidoes);