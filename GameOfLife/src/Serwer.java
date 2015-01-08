import com.ericsson.otp.erlang.*;
 
public class Serwer {
    
	public static void main(String[] args) throws Exception {
        
		OtpNode node = new OtpNode("java");
        OtpMbox mbox = node.createMbox("echo");
        Frame frame = new Frame();
        
        while (true) {
            
        	OtpErlangObject message = mbox.receive();
            String mes = message.toString();
            
            int i=1;
            while(mes.charAt(i)!=',')
            	i++;
            int X = Integer.valueOf(mes.substring(1, i));
            int Y = Integer.valueOf(mes.substring(i+1, mes.length()-1));
                    
            Plansza.setPlansza(X-1, Y-1);
            frame.repaint();
           
        }
    }
}