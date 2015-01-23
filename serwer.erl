-module(serwer).
-compile(export_all).


%-------------------------
%start procesu nadrzednego
start() -> spawn_link(?MODULE,init,[10,10]).

init(Szer,Wys) ->
	init(Szer,Wys,stworz_kom(1,1,Szer,Wys,[])).

%-------------------------
%funkcja wysyla kazdej komorce liste PID jej sasiadow
%wybiera komorki, ktore maja byc zywe na starcie i
%startuje gre w zycie
%Argumenty: rozmiary wyswietlacza(szerokosc i wysokosc)
%		i lista krotek {X,Y,Pid}-> wspolrzedne i 
%			Pid komorki
init(Szer,Wys,Lista) ->
	init_sasiedzi(Lista,Lista,Szer,Wys),
	init_poczatkowe_C(Lista),
	serwerRun(Lista).

%-------------------------
%synchronizacja pracy komorek
serwerRun(Lista) -> 
	receive
		stop -> stop(Lista)
			
		after 400 -> ping(Lista)
	end,
	serwerRun(Lista).

%<><><>><><><><><><><><><><><>><><><>
%zakonczenie dzialania
stop([]) -> ok;
stop([{_,_,PID}|T]) -> 
	PID ! {stop},
	stop(T).
%<><><>><><><><><><><><><><><>><><><>



%---------------------------------------------------
%wyslanie kazdej komorce jej sasiadow
init_sasiedzi([],_,_,_) -> ok;
init_sasiedzi([{X,Y,PID}|T],Lista,Szer,Wys) ->
	PID ! {init,sasiedzi({X,Y,PID},Lista,Szer,Wys)},
	init_sasiedzi(T,Lista,Szer,Wys).

%---------------------------------------------------
%zwraca liste Pid sasiadow kazdej komorki
%
sasiedzi({X,Y,_},Lista,Szer,Wys) when X > 1, Y > 1, X < Szer, Y < Wys -> 
	[znajdz(X - 1,Y-1,Lista), znajdz(X-1,Y,Lista), znajdz(X - 1,Y + 1,Lista),
	znajdz(X,Y - 1,Lista), znajdz(X,Y+1,Lista),
	znajdz(X + 1,Y - 1,Lista), znajdz(X+1,Y,Lista),znajdz(X + 1,Y + 1,Lista)];
%
%
sasiedzi({X,Y,_},Lista,Szer,_) when X > 1, Y == 1, X < Szer  -> 
	[znajdz(X - 1,Y,Lista), znajdz(X + 1,Y,Lista), znajdz(X - 1,Y + 1,Lista),
	znajdz(X,Y + 1,Lista), znajdz(X + 1,Y + 1,Lista)];
sasiedzi({X,Y,_},Lista,_,Wys) when X == 1, Y > 1, Y < Wys  -> 
	[znajdz(X + 1 ,Y,Lista), znajdz(X ,Y + 1,Lista), znajdz(X,Y - 1,Lista),
	znajdz(X + 1,Y - 1,Lista), znajdz(X + 1,Y + 1,Lista)];
sasiedzi({X,Y,_},Lista,Szer,Wys) when X == Szer, Y > 1, Y < Wys -> 
	[znajdz(X - 1 ,Y,Lista), znajdz(X - 1 ,Y + 1,Lista), znajdz(X - 1,Y - 1,Lista),
	znajdz(X ,Y - 1,Lista), znajdz(X ,Y + 1,Lista)];
sasiedzi({X,Y,_},Lista,Szer,Wys) when X > 1 , Y == Wys, X < Szer  -> 
	[znajdz(X - 1 ,Y,Lista), znajdz(X - 1,Y - 1,Lista), znajdz(X,Y - 1,Lista),
	znajdz(X  + 1,Y - 1,Lista), znajdz(X + 1 ,Y ,Lista)];
%
%
sasiedzi({X,Y,_},Lista,_,_) when X == 1, Y == 1 -> 
	[znajdz(X + 1 ,Y,Lista), znajdz(X ,Y + 1,Lista), znajdz(X + 1,Y + 1,Lista)];
sasiedzi({X,Y,_},Lista,_,Wys) when X == 1, Y == Wys -> 
	[znajdz(X + 1 ,Y,Lista), znajdz(X ,Y - 1,Lista), znajdz(X + 1,Y - 1,Lista)];
sasiedzi({X,Y,_},Lista,Szer,Wys) when X == Szer, Y == Wys -> 
	[znajdz(X - 1 ,Y,Lista), znajdz(X ,Y - 1,Lista), znajdz(X - 1,Y - 1,Lista)];
sasiedzi({X,Y,_},Lista,Szer,_) when X == Szer, Y == 1 -> 
	[znajdz(X - 1 ,Y,Lista), znajdz(X ,Y + 1,Lista), znajdz(X - 1,Y + 1,Lista)];

sasiedzi(_,_,_,_) -> [].	
	

%---------------------------------------------------	
%znajdz Pid dla podanego X i Y w liscie krotek{X,Y,PID}
znajdz(X,Y,[{Xx,Yy,PID}|_]) when X == Xx, Y == Yy -> PID;
znajdz(X,Y,[_|T]) -> znajdz(X,Y,T).


%---------------------------------------------------
%wysylamy ping do kazdej komorki(synchronizacja)
ping([]) -> ok;
ping([{_,_,PID}|T]) -> 
	PID ! {ping},
	ping(T).


%---------------------------------------------------
%odpalamy kazda komorke i tworzymy liste krotek {X,Y, pid} 
%dla tablicy Szer X Wys
stworz_kom(X,_,Szer,_,L) when X > Szer -> L;
stworz_kom(X,Y,Szer,Wys,L) when Y > Wys ->
	stworz_kom(X+1,1,Szer,Wys,L);
stworz_kom(X,Y,Szer,Wys,L) ->
	stworz_kom(X,Y+1,Szer,Wys,[{X,Y,komorka:start(X,Y)}|L]).




%---------------------------------------------------
%---------------------------------------------------
%kilka wariantow funkcji ozywiajacej komorki
%przed startem gry
%---------------------------------------------------
%---------------------------------------------------

%ustaw stan komorki	
ustaw_stan(PID,Stan) -> PID ! {set, Stan}.

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%wariant A ->(dla kazdej komorki)wybieramy 
%jaka jest szansa na ozywienie komorki {1,2,3,...,100}
%losujemy liczbe z przedzialu od 1 do wczeœnij wybranej liczby i 
%podejmujemy decyzje czy ozywic komorke
init_poczatkowe_A(_,[]) -> ok;
init_poczatkowe_A(Rand,[{_,_,PID}|T]) ->
	decyzja(random:uniform(Rand),PID),
	init_poczatkowe_A(Rand,T).

decyzja(Rand,PID) when Rand == 1 ->
	ustaw_stan(PID,zyje);
decyzja(_,_) -> ok.

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%wariant B 
init_poczatkowe_B(Lista) ->
	znajdz(5,5,Lista) ! {set,zyje},
	znajdz(6,6,Lista) ! {set,zyje},
	znajdz(5,6,Lista) ! {set,zyje},
	znajdz(6,5,Lista) ! {set,zyje},
	
	znajdz(3,3,Lista) ! {set,zyje},
	znajdz(3,4,Lista) ! {set,zyje}
	.
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%wariant C 
init_poczatkowe_C(Lista) ->
	znajdz(5,5,Lista) ! {set,zyje},
	znajdz(5,6,Lista) ! {set,zyje},
	znajdz(5,7,Lista) ! {set,zyje}.

