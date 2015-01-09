-module(komorka).
-compile(export_all).


start(X,Y,PID) ->
	spawn_link(?MODULE, init, [X,Y,PID,[],niezyje,0]).

init(X,Y,PID,Sasiedzi,Stan,LicznikZyjacych) -> 
	try run(X,Y,PID,Sasiedzi,Stan,LicznikZyjacych) 
	catch _ -> io:fwrite("Komorka X , Y umarla")
	end.


run(X,Y,PID,Sasiedzi,Stan,LicznikZyjacych) ->
	receive
		{change,zyje} -> io:fwrite("zyje"),
			run(X,Y,PID,Sasiedzi,Stan, (LicznikZyjacych + 1));

		{change,niezyje} -> 
			run(X,Y,PID,Sasiedzi,Stan,LicznikZyjacych);

		{ping} -> 

			wyslij_sasiadom(sprawdz(Stan,LicznikZyjacych),Sasiedzi),			rysuj(PID,Stan, sprawdz(Stan,LicznikZyjacych), X, Y),
			run(X,Y,PID,Sasiedzi,sprawdz(Stan,LicznikZyjacych),0);

		{init,InitSasiedzi} ->
			run(X,Y,PID,InitSasiedzi,Stan,LicznikZyjacych);

		{set,SetStan} ->
			wyslij_sasiadom(zyje,Sasiedzi),
			rysuj(PID,niezyje,zyje, X, Y),
			run(X,Y,PID,Sasiedzi,zyje,LicznikZyjacych)
		
	end.
	

sprawdz(zyje,2) ->zyje;
sprawdz(zyje,3) ->zyje;
sprawdz(niezyje,3) ->zyje;
sprawdz(_,_) ->niezyje.  

wyslij_sasiadom(_,[]) -> ok;
wyslij_sasiadom(Stan,[PID|T]) -> 
	PID ! {change,Stan},
	wyslij_sasiadom(Stan,T).

rysuj(_,Stan,NewStan,_,_) when Stan == NewStan -> ok;
rysuj(PID,_,_,X,Y) ->
	PID ! {rysuj,X,Y},
	ok.
	
		