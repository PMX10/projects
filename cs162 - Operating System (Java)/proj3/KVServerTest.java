package edu.berkeley.cs162;

import static org.junit.Assert.*;


import java.io.IOException;

import org.junit.Test;

public class KVServerTest {

	@Test
	public void test() {
			KVServer key_server = null;
			SocketServer server = null;
			StartUpThread accept;
			
			ClientThread t1 = new ClientThread("localhost", 8080, "put", "one", "1");
			ClientThread t2 = new ClientThread("localhost", 8080, "put", "two", "2");
			ClientThread t3 = new ClientThread("localhost", 8080, "get", "one", null);
			ClientThread t4 = new ClientThread("localhost", 8080, "del", "two", null);
			ClientThread t5 = new ClientThread("localhost", 8080, "put", "one", "5");
			ClientThread t6 = new ClientThread("localhost", 8080, "put", "six", "6");
			ClientThread t7 = new ClientThread("localhost", 8080, "put", "four", "4");
			ClientThread t8 = new ClientThread("localhost", 8080, "del", "six", null);
			ClientThread t9 = new ClientThread("localhost", 8080, "del", "two", null);
			ClientThread t10 = new ClientThread("localhost", 8080, "get", "six", null);
			
			key_server = new KVServer(100, 10);
			server = new SocketServer("localhost", 8080);
			NetworkHandler handler = new KVClientHandler(key_server);
			server.addHandler(handler);
			try {
			server.connect();
			accept = new StartUpThread(server);
			new Thread(accept).start();
			}
			catch (IOException e)
			{
				// Silently drop exception
			}
			System.out.println("Connected");
			
			Thread thread1 = new Thread(t1);
			Thread thread2 = new Thread(t2);
			Thread thread3 = new Thread(t3);
			Thread thread4 = new Thread(t4);
			Thread thread5 = new Thread(t5);
			Thread thread6 = new Thread(t6);
			Thread thread7 = new Thread(t7);
			Thread thread8 = new Thread(t8);
			Thread thread9 = new Thread(t9);
			Thread thread10 = new Thread(t10);
			
			thread1.start();
			thread2.start();
			thread3.start();
			thread4.start();
			thread5.start();
			thread6.start();
			thread7.start();
			thread8.start();
			thread9.start();
			thread10.start();
			
			try
			{
				thread1.join();
				thread2.join();
				thread3.join();
				thread4.join();
				thread5.join();
				thread6.join();
				thread7.join();
				thread8.join();
				thread9.join();
				thread10.join();
			}
			catch (InterruptedException e)
			{
				// Silently drop exception
			}
		}
	private class StartUpThread implements Runnable 
	{
		private SocketServer s = null;
		public StartUpThread (SocketServer s)
		{
			this.s = s;
		}
		
		public void run ()
		{
			try
			{
				s.run();
			}
			catch (IOException e)
			{
				// Silently drop exception
			}
		}
	}
	private class ClientThread implements Runnable
	{
		KVClient client;
		String request;
		String key;
		String value;
		
		public ClientThread(String host, int port, String request, String key, String value)
		{
			client = new KVClient(host,port);
			this.request = request;
			this.key = key;
			this.value = value;
		}
		
		public void run() {
			try
			{
				if (request.compareTo("get") == 0)
				{
					value = client.get(key);
				}
				if (request.compareTo("put") == 0)
				{
					client.put(key, value);
				}
				if (request.compareTo("del") == 0)
				{
					client.del(key);
				}
			}
			catch (KVException e)
			{
				System.out.println(this.request+" "+this.key+" "+e.getMsg().getMessage());
			}
			finally 
			{
			System.out.println(request.toUpperCase() + ":\nKey: " + key + "\nValue: " + value);
			}
		}
	}

}
