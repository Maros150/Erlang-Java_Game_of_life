-module(komorka).
-compile(export_all).



%-------------------------
%proces obslugujacy dzialanie komorki
%o wspolrzednych X i Y
start(X,Y) ->
	spawn_link(?MODULE, init, [X,Y]).


%-------------------------
%wylapywanie wyjatkow i przedwczesnego zakonczenia
%dzialania komorki
init(X,Y) -> 
	receive
		{init,InitSasiedzi,InitPID} ->
			run(X,Y,InitPID,InitSasiedzi,Stan, LicznikZyjacych)
	end.





%------------------------------------------------------
%glowna funkcja obslugujaca dzialanie komorki
%Argumenty:
%	-wspolrzedne X i Y
%	-lista PID wszystkich 8 sasiadow
%	-aktualny stan komorki (zyje lub niezyje)
%	-licznik zyjacych sasiadow
%
%{init,InitSasiedzi} - proces nadrzedny wysyla kazdej komorce
%			 liste jej sasiadow
%{set,SetStan} - do ozywiania komorek na starcie
%{ping} - proces nadrzedny zezwala na kolejny krok,
%		obliczamy nowy stan,
%		informujemy sasiadow o swoim stanie,
%		jesli stan komorki sie zmienil informujemy o tym
%		 program do rysowania
%		zerujemy licznik zyjacych  						
%{change,zyje},{change,niezyje} - odebranie wiadomosci			 
%		z jego aktualnym stanem od sasiada,
%		jesli zyje zwiekszamy licznik zyjacych sssiadow
run(X,Y,PID,Sasiedzi,Stan,LicznikZyjacych) ->
	receive
		{ping} -> 
			rysuj(PID,Stan, sprawdz(Stan,LicznikZyjacych), X, Y),
			wyslij_sasiadom(sprawdz(Stan,LicznikZyjacych),Sasiedzi),
			oczekiwanie(X,Y,PID,Sasiedzi,sprawdz(Stan,LicznikZyjacych),0,1);
		{set,SetStan} ->
			run(X,Y,PID,Sasiedzi,niezyje,3);
		{stop} -> ok
		
	end.



oczekiwanie(X,Y,PID,Sasiedzi,Stan,LicznikZyjacych,Licznik) ->
	io:format("unexpected message ~p {~p}[~p;~p]~n", [Licznik,length(Sasiedzi),X,Y ]),
	receive 
		{change,zyje} -> 
		case length(Sasiedzi)  of 
			Licznik  ->
				run(X,Y,PID,Sasiedzi,Stan, (LicznikZyjacych + 1));
			_ ->	
				oczekiwanie(X,Y,PID,Sasiedzi,Stan,LicznikZyjacych + 1,Licznik + 1)
		end;
		{change,niezyje} -> 
		case length(Sasiedzi)  of 
			Licznik    ->
				run(X,Y,PID,Sasiedzi,Stan, LicznikZyjacych);
			_ ->
				oczekiwanie(X,Y,PID,Sasiedzi,Stan,LicznikZyjacych,Licznik + 1)
		end
				
	end.

%------------------------------------------------------	
%zasady gry 
sprawdz(zyje,2) ->zyje;
sprawdz(zyje,3) -> zyje;
sprawdz(niezyje,3) -> zyje;
sprawdz(_,_) ->niezyje.  

%------------------------------------------------------
%funkcja wysylajaca sasiadom komorki wiadomosc z 
%aktualnym jej stanem
wyslij_sasiadom(_,[]) -> ok;
wyslij_sasiadom(Stan,[PID|T]) -> 
	PID ! {change,Stan},
	wyslij_sasiadom(Stan,T).

%------------------------------------------------------
%wyslanie wspolrzednych komorki do programu rysujacego
%jesli komorka zmienila swoj stan
rysuj(Stan,NewStan,_,_) when Stan == NewStan -> ok;
rysuj(_,_,X,Y) ->
	{echo,java@} ! {X,Y},
	ok.
	
		

