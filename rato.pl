% Grupo X - Rodrigo istid - Nuno istid

% menorf(L_abs, no(C, F, G, H, M)) - Escolhe de L_abs o no com menor f
% expande_no(No, L_sucs, EstadoFinal) :- L_sucs e a lista dos sucessores do No quando expandido para atingir o EstadoFinal
% expande(C, Exp) - Exp e a lista de todas as expansoes de C
% dist_Hamming(C1, C2, Dist) :- Dist e a distancia de Hamming entre C1 e C2
% resolve_cego(C1, C2) - Resolve o puzzle de forma ineficiente, esgotando as jogadas possiveis
% wDirecao(Direcao) :- Escreve uma das direcoes possiveis no ecra.
% resolve_manual(C1, C2) - Deixa o utilizador 'jogar' o puzzle
% wTransformacaoDesejada(C1, C2) - escreve a transformacao desejada de C1 para C2
% wTabuleiro(T) :- escreve um tabuleiro no ecra
% wLinha(L) - escreve uma lista de inteiros como uma linha no ecra
% wInt(N) :- escreve um dado N no ecra seguido de um espaco. Caso N = 0 escreve um espaco
% mov_legal(C1, M, P, C2) - C2 e C1 apos M pela peca P
% mov_possivel(C1, M, P) - E possivel fazer o movimento M a peca P em C1
% le_indice(L, I, P) - P esta no indice I da lista L1 (comeca em 0)
% troca_0_p(L1, P,L2) - L2 resulta de trocar 0 com p

% ESTRUTURA - no(C, F, G, H, M):
% C - Configuracao
% F - Soma de G e H
% G - Numero de transformacoes desde o estado inicial
% H - Heuristica (no nosso caso - distancia de Hamming).
% M - Movimentos para atingir este no desde a configuracao inicial.
% Construtor -
faz_no(C, F, G, H, M, no(C, F, G, H, M)).
% Seletores -
no_C(no(C, _, _, _, _), C).
no_F(no(_, F, _, _, _), F).
no_G(no(_, _, G, _, _), G).
no_H(no(_, _, _, H, _), H).
no_M(no(_, _, _, _, M), M).
% Modificadores - 
muda_C(C, no(_, F, G, H, M), no(C, F, G, H, M)).
muda_F(F, no(C, _, G, H, M), no(C, F, G, H, M)).
muda_G(G, no(C, F, _, H, M), no(C, F, G, H, M)).
muda_H(H, no(C, F, G, _, M), no(C, F, G, H, M)).
muda_M(M, no(C, F, G, H, _), no(C, F, G, H, M)).


% menorf(L_abs, no(C, F, G, H, M)) - Escolhe de L_abs o no com menor f
menorf([PN|RN], No) :- no_F(PN, F), menorf_aux(RN, No, PN, F).
menorf_aux([], No, No, _).
menorf_aux([P|R], No, _, F_anterior) :- no_F(P, F_actual),
												F_actual < F_anterior,
												menorf_aux(R, No, P, F_actual), !.
menorf_aux([P|R], No, No_actual, F_anterior) :- no_F(P, F_actual),
												F_actual >= F_anterior,
												menorf_aux(R, No, No_actual, F_anterior), !.

% expande_no(No, L_sucs, EstadoFinal) :- L_sucs e a lista dos sucessores do No quando expandido para atingir o EstadoFinal
expande_no(No, L_sucs, EstadoFinal) :- no_C(No, C_no),
									   expande(C_no, Exp),
									   expande_no_aux(No, L_sucs, EstadoFinal, Exp, []).
expande_no_aux(_, Aux, _, [], Aux).
expande_no_aux(No, L_sucs, EstadoFinal, [PExp, MExp | RExp], Aux) :- no_G(No, G), no_M(No, M), 
																	 append(M, [MExp], Novo_M),
															   		 dist_Hamming(PExp, EstadoFinal, Novo_H),
															   	     Novo_G is G + 1,
															         Novo_F is Novo_G + Novo_H,
							                        				 faz_no(PExp, Novo_F, Novo_G, Novo_H, Novo_M, NoExp),
							                        				 append(Aux, [NoExp], Novo_Aux),
							                        				 expande_no_aux(No, L_sucs, EstadoFinal, RExp, Novo_Aux), !.


% expande(C, Exp) - Exp e a lista de todas as expansoes de C na forma [Exp1, Mov1, ..., ExpN, MovN] 
expande(C, Exp) :- expande_aux(C, Exp, []).
expande_aux(C, Exp, Aux) :- mov_legal(C, M, _, C_Temp),
							\+ member(C_Temp, Aux), !,
							append(Aux, [C_Temp, M], Aux_1),
							expande_aux(C, Exp, Aux_1).
expande_aux(_, Aux, Aux).
			   

% dist_Hamming(C1, C2, Dist) :- Dist e a distancia de Hamming entre C1 e C2
dist_Hamming(C1, C2, Dist) :- dist_Hamming_aux(C1, C2, Dist, 0).
dist_Hamming_aux([], [], Dist, Dist).
dist_Hamming_aux([P | RC1], [P | RC2], Dist, Aux) :- dist_Hamming_aux(RC1, RC2, Dist, Aux), !.
dist_Hamming_aux([_ | RC1], [_ | RC2], Dist, Aux) :- Aux_1 is Aux + 1,
														 dist_Hamming_aux(RC1, RC2, Dist, Aux_1).

% resolve_cego(C1, C2) - Resolve o puzzle de forma ineficiente, esgotando as jogadas possiveis
resolve_cego(C1, C2) :- nl, writeln('Transformacao desejada:'),
						wTransformacaoDesejada(C1, C2), nl,
						resolve_cego_aux(C1, C2, [C1]),
						writeln('.').
% resolve_cego_aux(C1, C2, L) :- L e a lista de todos os tabuleiros anteriores
resolve_cego_aux(C, C, _) :- !.
resolve_cego_aux(C1, C2, L) :- mov_legal(C1, M, P, C1_Temp),
							   \+ member(C1_Temp, L),
							   append([C1_Temp], L, L_temp),
							   nl, write('mova a peca '),
							   write(P),
							   write(' para '),
							   wDirecao(M),
							   resolve_cego_aux(C1_Temp, C2, L_temp).

% wDirecao(Direcao) :- Escreve uma das direcoes possiveis no ecra.
wDirecao(e) :- write('esquerda').
wDirecao(d) :- write('direita').
wDirecao(c) :- write('cima').
wDirecao(b) :- write('baixo').
wDirecao(_).

% resolve_manual(C1, C2) - Deixa o utilizador 'jogar' o puzzle
resolve_manual(C1, C2) :- nl, writeln('Transformacao desejada:'),
						  nl, wTransformacaoDesejada(C1, C2),
						  resolve_manual_aux(C1, C2).
resolve_manual_aux(C, C) :- nl, writeln('Parabens!').
resolve_manual_aux(C1, C2) :- nl, writeln('Qual o seu movimento?'),
							  read(Mov),
							  mov_legal(C1, Mov, _, C1_temp), !,
							  nl, wTabuleiro(C1_temp),
							  resolve_manual_aux(C1_temp, C2).
resolve_manual_aux(C1, C2) :- writeln('Movimento ilegal'),
							  resolve_manual_aux(C1, C2).

% wTabuleiro(T) :- escreve um tabuleiro T no ecra.
wTabuleiro([]).
wTabuleiro([A, B, C | R]) :- wLinha([A, B, C]), nl,
							 wTabuleiro(R).

% wTransformacaoDesejada(C1, C2) - escreve a Transformacao desejada no ecra.
wTransformacaoDesejada(C1, C2) :- wTransDes_aux(C1, C2, 1).
wTransDes_aux(_, _, 4).
wTransDes_aux([A, B, C | R1], [D, E, F | R2], Lin) :- wLinha([A, B, C]),
													  (Lin =:= 2
													     -> write('-> ')
													  	 ;  write('   ')
													  ),
													  wLinha([D, E, F]),
													  nl,
													  New_Lin is Lin + 1,
													  wTransDes_aux(R1, R2, New_Lin).

% wLinha(L) - escreve uma lista de inteiros como uma linha no ecra
wLinha([]).
wLinha([P | Q]) :- wInt(P), wLinha(Q).

% wInt(N) :- escreve um dado N no ecra seguido de um espaco. Caso N = 0 escreve um espaco
wInt(0) :- write('  ').
wInt(N) :- write(N), write(' ').

% mov_legal(C1, M, P, C2) - C2 e C1 apos M pela peca P
mov_legal(C1, M, P, C2) :-  mov_possivel(C1, M, P),
							troca_0_p(C1, P, C2). 
							
% mov_possivel(C1, M, P) - E possivel fazer o movimento M a peca P em C1
mov_possivel(C1, c, P) :- mov_possivel_aux(C1, P, 0, 1, 2, -3).
mov_possivel(C1, b, P) :- mov_possivel_aux(C1, P, 6, 7, 8, 3).
mov_possivel(C1, d, P) :- mov_possivel_aux(C1, P, 2, 5, 8, 1).
mov_possivel(C1, e, P) :- mov_possivel_aux(C1, P, 0, 3, 6, -1).
% Em que Lim1, Lim2 e Lim3 sao as posicoes onde o valor vazio nao pode estar
% para dado movimento e Step e o valor a aplicar a P para ficar onde esta o 0.
mov_possivel_aux(C1, P, Lim1, Lim2, Lim3, Step) :- le_indice(C1, IndP, P),
												   \+ le_indice(C1, Lim1, P),
												   \+ le_indice(C1, Lim2, P),
												   \+ le_indice(C1, Lim3, P),
												   IndP_1 is IndP + Step,
												   le_indice(C1, IndP_1, 0).
										   
% le_indice(L, I, P) - P esta no indice I da lista L1 (comeca em 0)
le_indice(L, I, P) :- le_indice_aux(L, I, P, 0).
le_indice_aux([P | _], Aux, P, Aux).
le_indice_aux([_ | RP], I, P, Aux) :- Aux_1 is Aux + 1,
									  le_indice_aux(RP, I, P, Aux_1). 

% troca_0_p(L1, P,L2) - L2 resulta de trocar 0 com p
troca_0_p(L1, P,L2) :- troca_0_p(L1,P,L2,[]).
troca_0_p([],_,L2,L2).
troca_0_p([P|RL1],P,L2, Aux) :- append(Aux,[0],L_Aux),
								troca_0_p(RL1, P, L2, L_Aux),!.
troca_0_p([0|RL1],P,L2, Aux) :- append(Aux,[P],L_Aux),
								troca_0_p(RL1, P, L2, L_Aux),!.
troca_0_p([PL1|RL1],P,L2, Aux) :- append(Aux,[PL1],L_Aux),
								troca_0_p(RL1,P,L2, L_Aux).