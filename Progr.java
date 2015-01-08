import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;


public class Progr {

	public static void main(String[] args) throws IOException {
		String host ="localhost";
		Socket s = new Socket(host, 5678);

		System.out.println("Connected to socket on: " + host + ":" + 2345);

		DataOutputStream os = new DataOutputStream(s.getOutputStream());

		String a = "Hello, world |23|24|26.";

		os.write(a.getBytes());

		BufferedReader in = new BufferedReader(new
		InputStreamReader(s.getInputStream()));
		int i =0;
		while(i<10000){
		System.out.println("echo: " + in.read());
		i++;
		}
		
		s.close();
	}

}
