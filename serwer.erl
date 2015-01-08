-module(serwer).
-compile(export_all).
-rr(komorka).
-rr(port).

init(Szer,Wys) -> init(Szer,Wys,stworz_kom(1,1,Szer,Wys,[])).

init(Szer,Wys,Lista) ->
	init_sasiedzi(Lista,Lista,Szer,Wys),
	init_poczatkowe_B(Lista),
	serwerRun(Lista).


serwerRun(Lista) -> 
	receive
		after 9000 -> ping(Lista)
	end,
	serwerRun(Lista).



init_sasiedzi([],_,_,_) -> ok;
init_sasiedzi([{X,Y,PID}|T],Lista,Szer,Wys) ->
	PID ! {init,sasiedzi({X,Y,PID},Lista,Szer,Wys)},
	init_sasiedzi(T,Lista,Szer,Wys).

sasiedzi({X,Y,_},Lista,Szer,Wys) when X > 1, Y > 1, X < Szer, Y < Wys -> 
	[znajdz(X-1,Y-1,Lista), znajdz(X-1,Y,Lista), znajdz(X-1,Y+1,Lista),
	znajdz(X,Y-1,Lista), znajdz(X,Y+1,Lista),
	znajdz(X+1,Y-1,Lista), znajdz(X+1,Y,Lista),znajdz(X+1,Y+1,Lista)];
sasiedzi(_,_,_,_) -> [].	
	
znajdz(X,Y,[{Xx,Yy,PID}|_]) when X == Xx, Y == Yy -> PID;
znajdz(X,Y,[_|T]) -> znajdz(X,Y,T).

ping([]) -> ok;
ping([{_,_,PID}|T]) -> 
	PID ! {ping},
	ping(T).

stworz_kom(X,_,Szer,_,L) when X > Szer -> L;
stworz_kom(X,Y,Szer,Wys,L) when Y > Wys ->
	stworz_kom(X+1,1,Szer,Wys,L);
stworz_kom(X,Y,Szer,Wys,L) ->
	stworz_kom(X,Y+1,Szer,Wys,[{X,Y,komorka:start(X,Y)}|L]).
	
ustaw_stan(PID,Stan) -> PID ! {set, Stan}.

init_poczatkowe_A(_,[]) -> ok;
init_poczatkowe_A(Rand,[{_,_,PID}|T]) ->
	decyzja(random:uniform(Rand),PID),
	init_poczatkowe_A(Rand,T).

decyzja(Rand,PID) when Rand == 1 ->
	ustaw_stan(PID,zyje);
decyzja(_,_) -> ok.

init_poczatkowe_B(Lista) ->
	znajdz(5,5,Lista) ! {set,zywa},
	znajdz(6,6,Lista) ! {set,zywa},
	znajdz(5,6,Lista) ! {set,zywa},
	znajdz(6,5,Lista) ! {set,zywa}
	
	%znajdz(3,3,Lista) ! {set,zywa},
	%znajdz(3,4,Lista) ! {set,zywa}.
	.
loop() ->
	io:fwrite("neieneinenienei"),
	loop().