-module(komorka).
-compile(export_all).
-rr(port)


start(X,Y) ->
	spawn_link(?MODULE, init, [X,Y,[],niezyje,0]).

init(X,Y,Sasiedzi,Stan,LicznikZyjacych) -> 
	try run(0,X,Y,Sasiedzi,Stan,LicznikZyjacych) 
	catch _ -> io:fwrite("Komorka X , Y umarla")
	end.


run(Port,X,Y,Sasiedzi,Stan,LicznikZyjacych) ->
	receive
		{change,zyje} ->	
			run(Port,X,Y,Sasiedzi,sprawdz(Stan,(LicznikZyjacych + 1)), (LicznikZyjacych + 1));

		{change,niezyje} ->
			run(Port,X,Y,Sasiedzi,sprawdz(Stan,(LicznikZyjacych)), (LicznikZyjacych));

		{ping} ->
			wyslij_sasiadom(sprawdz(Stan,LicznikZyjacych),Sasiedzi),
			run(Port,X,Y,Sasiedzi,sprawdz(Stan,LicznikZyjacych),0);
			
		{port,initPort} ->
			run(initPort,X,Y,Sasiedzi,sprawdz(Stan,(LicznikZyjacych)), (LicznikZyjacych));

		{init,InitSasiedzi} ->
			run(Port,X,Y,InitSasiedzi,Stan,LicznikZyjacych);

		{set,SetStan} ->
			run(Port,X,Y,Sasiedzi,SetStan,LicznikZyjacych)	 
	end.
	

sprawdz(zyje,2) ->zyje;
sprawdz(zyje,3) -> zyje;
sprawdz(niezyje,3) -> zyje;
sprawdz(_,_) ->niezyje.  

wyslij_sasiadom(_,[]) -> ok;
wyslij_sasiadom(Stan,[PID|T]) -> 
	PID ! {change,Stan},
	wyslij_sasiadom(Stan,T).

