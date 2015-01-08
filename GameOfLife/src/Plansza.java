
public class Plansza {
	
	static boolean[][] plansza = new boolean[10][10];
	
	static void setPlansza(int x, int y){
		
		plansza[x][y]= !plansza[x][y];
	}
}
