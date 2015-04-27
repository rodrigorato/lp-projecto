%   cenas aqui

/*
% mov_legal(C1, M, P, C2) - C1 apos M pela peca P resulta em C2
mov_legal(C1, M, P, C2) :-  mov_possivel(C1, M, P),
							aplica_mov(C1, M, P).
							C1 is C2. 
*/

% mov_possivel(C1, M, P) - E possivel fazer o movimento M a peca P em C1
mov_possivel(C1, M, P) :- M == d -> mov_possivel_aux(C1, P, 2, 5, 8, 1);
						  M == e -> mov_possivel_aux(C1, P, 0, 3, 6, -1);
						  M == c -> mov_possivel_aux(C1, P, 0, 1, 2, -3);
						  M == b -> mov_possivel_aux(C1, P, 6, 7, 8, 3).

mov_possivel_aux(C1, P, Lim1, Lim2, Lim3, Step) :- \+ le_indice(C1, Lim1, P),
												   \+ le_indice(C1, Lim2, P),
												   \+ le_indice(C1, Lim3, P),
												   le_indice(C1, IndP, P),
												   IndP_1 is IndP + Step,
												   le_indice(C1, IndP_1, 0).
												   



% le_indice(L, I, P) - P esta no indice I da lista L1 (comeca em 0)
le_indice(L, I, P) :- le_indice_aux(L, I, P, 0).
le_indice_aux([P | _], Aux, P, Aux) :- !.
le_indice_aux([_ | RP], I, P, Aux) :- Aux_1 is Aux + 1,
									  le_indice_aux(RP, I, P, Aux_1). 