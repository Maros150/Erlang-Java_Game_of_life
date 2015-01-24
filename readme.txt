Start:
serwer:start(). -zwraca Pid procesu nadrz�dnego 


Stop:
Pid ! stop.



Kr�tki opis:

	Tworzymy proces nadrz�dny, kt�ry uruchamia procesy reprezentuj�ce
kom�rki na wy�wietlanej planszy. Proces nadrz�dny przechowuje informacje 
o poszczeg�lnych kom�rkach w li�cie krotek {X,Y,Pid}, gdzie X,Y to wsp�rz�dne.
Przed rozpocz�ciem gry proces nadrz�dny wysy�a ka�dej stworzonej kom�rce list� 
jej s�siad�w i o�ywia wybrane kom�rki. Nast�pnie co 50 milisekund sekund 
wysy�a ka�dej kom�rce wiadomo�� {ping}, jednocze�nie oczekuj�c na wiadomo�� stopu.
Po otrzymaniu wiadomo�ci: 'stop' przesy�a j� wszystkim kom�rk� i ko�czy prac�.

Komorka:
	Tworz�c kom�rk� ustawiamy jej stan na 'niezyje', licznikowi �ywych 
s�siad�w przypisujemy warto�� 0 i przypisujemy jej list� s�siad�w otrzymanych 
od procesu nadrz�dnego.
	Kom�rka czeka na wiadomo�� od procesu nadrz�dnego:
		{ping}
		{set,_Stan} o�ywia komorke
		{stop} konczy prace
	Kom�rka po otrzymaniu widomo�ci: {ping}  oblicza nowy stan(�yje/nie�yje)
na podstawie licznika �ywych s�siad�w. Je�eli stan kom�rki si� zmieni� wysy�a
do programu odpowiadaj�cego za wy�wietlanie gry swoje wsp�rz�dne. Nast�pnie
wysy�a s�siadom wiadomo�� informuj�c o swoim aktualnym stanie, zeruje licznik �ywych
s�siad�w i oczekuje wiadomo�ci od wszystkich s�siad�w. Je�eli s�siednia kom�rka
jest �ywa, licznik �ywych s�siad�w jest zwi�kszany o jeden. Gdy kom�rka odbierze
wiadomo�ci od wszystkich s�siad�w przechodzi w tryb oczekiwania na wiadomo�� od 
procesu nadrz�dnego.
	O�ywianie kom�rki przed startem gry polega na ustawieniu jej licznik �ywych 
s�siad�w na 3, dzi�ki czemu po otrzymaniu pierwszego {ping} jest o�ywiana     
