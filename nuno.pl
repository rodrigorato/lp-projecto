% Grupo X - Rodrigo istid - Nuno istid

% resolve_manual(C1, C2) - Deixa o utilizador 'jogar' o puzzle
% wTransformacaoDesejada(C1, C2) - escreve a transformacao desejada de C1 para C2
% wTabuleiro(T) :- escreve um tabuleiro no ecra
% wLinha(L) - escreve uma lista de inteiros como uma linha no ecra
% wInt(N) :- escreve um dado N no ecra seguido de um espaco. Caso N = 0 escreve um espaco
% mov_legal(C1, M, P, C2) - C2 e C1 apos M pela peca P
% mov_possivel(C1, M, P) - E possivel fazer o movimento M a peca P em C1
% le_indice(L, I, P) - P esta no indice I da lista L1 (comeca em 0)
% troca_0_p(L1, P,L2) - L2 resulta de trocar 0 com p
% NAO TA A SER USADO? - esc_indice(L1, I, P, L2) - L2 resulta de escrever P no indice I em L1.



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

% esc_indice(L1, I, P, L2) - L2 resulta de escrever P no indice I em L1.
esc_indice(L1, I, P, L2) :- le_indice(L1, I, P_em_I),
							lista_ate_p(L1, P_em_I, L2_ate_P),
							append(L2_ate_P, [P], L2_com_P),
							lista_desde_p(L1, P_em_I, L2_desde_P),
							append(L2_com_P, L2_desde_P, L2).