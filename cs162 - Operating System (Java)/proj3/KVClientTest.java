package edu.berkeley.cs162;

import static org.junit.Assert.*;

import org.junit.Test;

public class KVClientTest {
	@Test
	public void testPut() throws KVException {
		KVClient test = new KVClient("localhost", 8080);
		System.out.println("Putting (1,a)");
		test.put("1", "a");
	}
	
	
	
	@Test
	public void testGet() throws KVException {
		int port = 9000;
	
		KVClient test = new KVClient("localhost", 8080);
		System.out.println("Getting (1)..");
		System.out.println(test.get("1"));
		
	}
	
	
	
	@Test
	public void testDel() throws KVException {
		KVClient test = new KVClient("localhost", 8080);
		System.out.println("Deleting (1)..");
		test.del("1");
		
	}
	

}
