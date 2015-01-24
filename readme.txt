Start:
serwer:start(). -zwraca Pid procesu nadrzêdnego 


Stop:
Pid ! stop.



Krótki opis:

	Tworzymy proces nadrzêdny, który uruchamia procesy reprezentuj¹ce
komórki na wyœwietlanej planszy. Proces nadrzêdny przechowuje informacje 
o poszczególnych komórkach w liœcie krotek {X,Y,Pid}, gdzie X,Y to wspó³rzêdne.
Przed rozpoczêciem gry proces nadrzêdny wysy³a ka¿dej stworzonej komórce listê 
jej s¹siadów i o¿ywia wybrane komórki. Nastêpnie co 50 milisekund sekund 
wysy³a ka¿dej komórce wiadomoœæ {ping}, jednoczeœnie oczekuj¹c na wiadomoœæ stopu.
Po otrzymaniu wiadomoœci: 'stop' przesy³a j¹ wszystkim komórk¹ i koñczy pracê.

Komorka:
	Tworz¹c komórkê ustawiamy jej stan na 'niezyje', licznikowi ¿ywych 
s¹siadów przypisujemy wartoœæ 0 i przypisujemy jej listê s¹siadów otrzymanych 
od procesu nadrzêdnego.
	Komórka czeka na wiadomoœæ od procesu nadrzêdnego:
		{ping}
		{set,_Stan} o¿ywia komorke
		{stop} konczy prace
	Komórka po otrzymaniu widomoœci: {ping}  oblicza nowy stan(¿yje/nie¿yje)
na podstawie licznika ¿ywych s¹siadów. Je¿eli stan komórki siê zmieni³ wysy³a
do programu odpowiadaj¹cego za wyœwietlanie gry swoje wspó³rzêdne. Nastêpnie
wysy³a s¹siadom wiadomoœæ informuj¹c o swoim aktualnym stanie, zeruje licznik ¿ywych
s¹siadów i oczekuje wiadomoœci od wszystkich s¹siadów. Je¿eli s¹siednia komórka
jest ¿ywa, licznik ¿ywych s¹siadów jest zwiêkszany o jeden. Gdy komórka odbierze
wiadomoœci od wszystkich s¹siadów przechodzi w tryb oczekiwania na wiadomoœæ od 
procesu nadrzêdnego.
	O¿ywianie komórki przed startem gry polega na ustawieniu jej licznik ¿ywych 
s¹siadów na 3, dziêki czemu po otrzymaniu pierwszego {ping} jest o¿ywiana     
