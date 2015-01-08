import java.awt.Color;
import java.awt.Graphics;

import javax.swing.JApplet;


public class Aplet extends JApplet{

	static JApplet aplet;
	int size = 40;
	
	public void init(){
	
		aplet = this;
		aplet.setSize(600, 600);
		aplet.setBackground(Color.GRAY);
	
	}
	public void paint(Graphics g){
		
		drawTrack(g);
	}
	public void drawTrack(Graphics g){
		
		for(int i=0;i<Plansza.plansza.length;i++){
			for(int j=0;j<Plansza.plansza[0].length;j++){
				
				if(Plansza.plansza[i][j])
					g.setColor(Color.WHITE);
				else 
					g.setColor(Color.BLACK);
			
				g.fillRect(size*j, size*i, size, size);
			}
		}
	}
	
}
