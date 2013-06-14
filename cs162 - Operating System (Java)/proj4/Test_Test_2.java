/**
 * This test will tests End to End and jUnit for this project.
 * 
 * To run this test, follow these steps:
 * Run TPCMasterHandler_Server.java
 * Run jUnit TPCMasterHandler_Test_1.java
 * Stop TPCMasterHandler_Server.java
 * Run TPCMasterHandler_Server.java
 * Run jUnit TPCMasterHandler_Test_2.java
 */

package edu.berkeley.cs162;

import static org.junit.Assert.*;
import org.junit.Test;

import java.io.*;
import java.net.InetAddress;
import java.net.Socket;

/*  IMPORTANT: In order to run this test
 *  1. Comment out handler.registerWithMaster(masterHostName, server); in SlaveServer.java
 *  2. Run SlaveServer.java
 *  3. Get the random port assigned to the SlaveServer
 *  4. Change port = the random port number
 *  5. Run test
 */

public class Test_Test_2 {
	static String server = "localhost";
	static int port = 25989;	
	
	int run_2_correct = 0;
	static int run_2_expected = 1;
	
	Socket sock = null;
	
	@Test
	public void run_2() throws Exception{
		Socket sock;
		KVMessage message;
		KVMessage response;
		
		
		//=======================================================================================//
		//								SEND "get(1)" RECEIVED "resp"	(ignoreNext = false)							
		//=======================================================================================//
		sock = null;
		try {
			sock = new Socket(server, port);
		} catch(IOException wrongType ){
			KVMessage er = new KVMessage("resp","Network Error: Could not create socket");
			throw new KVException(er);
		} catch(Exception wrongType ){
			KVMessage er = new KVMessage("resp","Network Error: Could not connect");
			throw new KVException(er);
		}

		message = new KVMessage("getreq", "1");
		//message.setTpcOpId("123");

		message.toXML();
		message.sendMessage(sock);

		System.out.println("Finished sending data over socket");

		response = null;

		try {
			InputStream in = sock.getInputStream();
			response = new KVMessage(in);
		} catch(Exception wrongType ){
			KVMessage er = new KVMessage("resp","Network Error: Could not receive data");

			throw new KVException(er);
		}
		try {
			sock.close();
		} catch(IOException wrongType ){
			KVMessage er = new KVMessage("resp","Network Error: Could not create socket");
			throw new KVException(er);
		} 
		if(response.getMsgType() != null)
			System.out.println("TYPE: " + response.getMsgType());
		if(response.getKey() != null)
			System.out.println("KEY: " + response.getKey());
		if(response.getValue() != null)
			System.out.println("VALUE: " + response.getValue());
		
		if(response.getMsgType().equals("resp"))
			run_2_correct++;
		
		//=======================================================================================//	
		System.out.print(run_2_correct+"/");
		System.out.println(run_2_expected);
		
		assertEquals(run_2_correct, run_2_expected);
	}
}