-module(komorka).
-compile(export_all).


start(X,Y) ->
	spawn_link(?MODULE, init, [X,Y,[],niezyje,0]).

init(X,Y,Sasiedzi,Stan,LicznikZyjacych) -> 
	try run(X,Y,Sasiedzi,Stan,LicznikZyjacych) 
	catch _ -> io:fwrite("Komorka X , Y umarla")
	end.


run(X,Y,Sasiedzi,Stan,LicznikZyjacych) ->
	receive
		{change,zyje} ->	
			run(X,Y,Sasiedzi,sprawdz(Stan,(LicznikZyjacych + 1)), (LicznikZyjacych + 1));

		{change,niezyje} ->
			run(X,Y,Sasiedzi,sprawdz(Stan,(LicznikZyjacych)), (LicznikZyjacych));

		{ping} -> 
			%rysuj(Stan, sprawdz(Stan,LicznikZyjacych), X, Y),
			wyslij_sasiadom(sprawdz(Stan,LicznikZyjacych),Sasiedzi),
			run(X,Y,Sasiedzi,sprawdz(Stan,LicznikZyjacych),0);

		{init,InitSasiedzi} ->
			run(X,Y,InitSasiedzi,Stan,LicznikZyjacych);

		{set,SetStan} ->
			run(X,Y,Sasiedzi,SetStan,LicznikZyjacych)	 
	end.
	

sprawdz(zyje,2) ->zyje;
sprawdz(zyje,3) -> zyje;
sprawdz(niezyje,3) -> zyje;
sprawdz(_,_) ->niezyje.  

wyslij_sasiadom(_,[]) -> ok;
wyslij_sasiadom(Stan,[PID|T]) -> 
	PID ! {change,Stan},
	wyslij_sasiadom(Stan,T).

rysuj(Stan,NewStan,_,_) when Stan == NewStan -> ok;
rysuj(_,_,X,Y) ->
	{echo,java@} ! {X,Y},
	ok.
	
		