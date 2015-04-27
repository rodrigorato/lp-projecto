% Grupo X - Rodrigo istid - Nuno istid


% mov_legal(C1, M, P, C2) - C2 e C1 apos M pela peca P
mov_legal(C1, M, P, C2) :-  mov_possivel(C1, M, P),
							aplica_mov(C1, P, C2). 



% mov_possivel(C1, M, P) - E possivel fazer o movimento M a peca P em C1
mov_possivel(C1, M, P) :- M == d -> mov_possivel_aux(C1, P, 2, 5, 8, 1);
						  M == e -> mov_possivel_aux(C1, P, 0, 3, 6, -1);
						  M == c -> mov_possivel_aux(C1, P, 0, 1, 2, -3);
						  M == b -> mov_possivel_aux(C1, P, 6, 7, 8, 3).
% Em que Lim1, Lim2 e Lim3 sao as posicoes onde o valor vazio nao pode estar
% para dado movimento e Step e o valor a aplicar a P para ficar onde esta o 0.
mov_possivel_aux(C1, P, Lim1, Lim2, Lim3, Step) :- \+ le_indice(C1, Lim1, P),
												   \+ le_indice(C1, Lim2, P),
												   \+ le_indice(C1, Lim3, P),
												   le_indice(C1, IndP, P),
												   IndP_1 is IndP + Step,
												   le_indice(C1, IndP_1, 0).


% aplica_mov(C1, M, P, C2) - C2 resulta de Aplicar M a peca P em C1.
aplica_mov(C1, P, C2) :- 	le_indice(C1, Ind_0, 0),
							le_indice(C1, Ind_P, P),
							esc_indice(C1, Ind_0, P, C1_aux),
							esc_indice(C1_aux, Ind_P, 0, C2).										   

% le_indice(L, I, P) - P esta no indice I da lista L1 (comeca em 0)
le_indice(L, I, P) :- le_indice_aux(L, I, P, 0).
le_indice_aux([P | _], Aux, P, Aux) :- !.
le_indice_aux([_ | RP], I, P, Aux) :- Aux_1 is Aux + 1,
									  le_indice_aux(RP, I, P, Aux_1). 

% esc_indice(L1, I, P, L2) - L2 resulta de escrever P no indice I em L1.
esc_indice(L1, I, P, L2) :- le_indice(L1, I, P_em_I),
							lista_ate_p(L1, P_em_I, L2_ate_P),
							append(L2_ate_P, [P], L2_com_P),
							lista_desde_p(L1, P_em_I, L2_desde_P),
							append(L2_com_P, L2_desde_P, L2).


% lista_ate_p(L1, P, L2) - L2 e a lista dos elementos de L1 ate encontrar P (exclusive)
lista_ate_p([PL1 | RL1], P, L2) :- lista_ate_p_aux([PL1 | RL1], P, L2, []).
lista_ate_p_aux([P | _] , P, L2, L2) :- !.
lista_ate_p_aux([PL1 | RL1], P, L2, Aux) :- append(Aux, [PL1], Aux_1),
											lista_ate_p_aux(RL1, P, L2, Aux_1), !.

% lista_desde_p(L1, P, L2) - L2 e a lista dos elementos de L1 a partir de P (exclusive)
lista_desde_p([P | R], P, R) :- !.
lista_desde_p([_ | RL1], P, R) :- lista_desde_p(RL1, P, R), !.


