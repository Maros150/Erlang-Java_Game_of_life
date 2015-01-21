import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;


public class Progr {

	public static void main(String[] args) throws IOException, InterruptedException {
		String host ="localhost";
		Socket s = new Socket(host, 5678);

		System.out.println("Connected to socket on: " + host + ":" + 2345);

		DataOutputStream os = new DataOutputStream(s.getOutputStream());

		String a = "Hello, world |23|24|26.";


		BufferedReader in = new BufferedReader(new
		InputStreamReader(s.getInputStream()));
		int i =0;
		int x,y =0;
		while(i<2){
			x = (int)in.read();
			y = (int)in.read();
		System.out.println("X: " + x + " Y: " + y);
		
		i++;
		}
		String k = "exit";
		os.write(k.getBytes());
		Thread.sleep(50);
		s.close();
	}

}
