/**
 * Master for Two-Phase Commits
 * 
 * @author Mosharaf Chowdhury (http://www.mosharaf.com)
 * @author Prashanth Mohan (http://www.cs.berkeley.edu/~prmohan)
 *
 * Copyright (c) 2012, University of California at Berkeley
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *  * Neither the name of University of California, Berkeley nor the
 *    names of its contributors may be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *    
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 *  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *  DISCLAIMED. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY
 *  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package edu.berkeley.cs162;

import java.io.IOException;
import java.io.InputStream;
import java.net.InetAddress;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.TreeSet;
import java.lang.Thread;

//import TPCMaster.TPCRegistrationHandler.RegistrationHandler;

public class TPCMaster {
	
	/**
	 * Implements NetworkHandler to handle registration requests from 
	 * SlaveServers.
	 * 
	 */
	
	ArrayList<SlaveInfo> slaveList = new ArrayList<SlaveInfo>();
	
	private class TPCRegistrationHandler implements NetworkHandler {

		private ThreadPool threadpool = null;

		public TPCRegistrationHandler() {
			// Call the other constructor
			this(1);	
		}

		public TPCRegistrationHandler(int connections) {
			threadpool = new ThreadPool(connections);	
		}

		@Override
		public void handle(Socket client) throws IOException {
			// implement me
			Runnable r = new RegistrationHandler(client);
			try {
				threadpool.addToQueue(r);
			} catch (InterruptedException e) {
				// Ignore this error
				return;
			}
			
		}
		
		private class RegistrationHandler implements Runnable {
			// Instance variables
			private Socket client;
		
			// Constructor
			public RegistrationHandler(Socket client) {
				this.client = client;
			}
			private boolean isInList(SlaveInfo s){
				for (int i=0; i<slaveList.size(); i++){
					if (s.getSlaveID()==slaveList.get(i).getSlaveID())
						return true;
				}
				return false;
			}

			public void run() {
				//System.out.println("RegistrationHandler runs");
				try{
					int current_num_slaves = 0;
					
					//while(current_num_slaves < numSlaves)
					//{
						InputStream input = client.getInputStream();
						//System.out.println(input.toString());
						KVMessage msg = new KVMessage(input);
						SlaveInfo slaveServer = null;
						if(msg.getMsgType().equals("register"))
							slaveServer = new SlaveInfo(msg.getMessage());
						else 
							return;	//if the message type is not "register", nothing happened
							//continue;
						//System.out.println("----->"+msg.getMsgType()+"from"+slaveServer.hostName);
						//if the slave server is already in the list, update the host name and port
						if (slaveServer!=null)
						{
							if(slaveList.size()==numSlaves && !isInList(slaveServer))
							{
								String resp_msg = new String(slaveServer.getSlaveID() + "@" + slaveServer.hostName + ":" + slaveServer.port+" can not be added because number of slave servers reached maximum!");
								KVMessage response = new KVMessage("resp", resp_msg);
								response.sendMessage(client);
								client.close();
								return;
							}
							for (int i=0; i<slaveList.size(); i++)
							{
								if (slaveList.get(i).getSlaveID() == slaveServer.getSlaveID())
								{
									slaveList.get(i).hostName = slaveServer.hostName;
									slaveList.get(i).port = slaveServer.port;
									closeConnection(slaveServer, client);
									return;
								}
							}
							//otherwise, add it to slaveList to the right position
							int i;
							for (i=0; i<slaveList.size(); i++)
							{
								if (isLessThanUnsigned(slaveServer.getSlaveID(), slaveList.get(i).getSlaveID()))
								{
									slaveList.add(i, slaveServer);
									//slaveServer.wait();
									current_num_slaves++;
									break;
								}
							}
							if (slaveList.size() == 0||i==slaveList.size())
							{
								slaveList.add(slaveServer);
								//slaveList.get(0).wait();
								current_num_slaves++;
							}
						}
						closeConnection(slaveServer, client);
						//for(int i=0;i<slaveList.size();i++)
							//System.out.println(slaveList.get(i).slaveID);
				}//try
				catch (KVException err) {
					//System.out.println(err.getMsg());
				}
				catch (IOException err) {
					
				}
				//catch(InterruptedException err)
			//	{
					
				//}
				//slaveList.notifyAll();
			}
			private void closeConnection(SlaveInfo slaveServer, Socket sock) throws KVException, IOException{
				// ack back if slave server is successfully added
	        	String resp_msg = new String("Successfully registered " + slaveServer.getSlaveID() + "@" + slaveServer.hostName + ":" + slaveServer.port);
	        	KVMessage response = new KVMessage("resp", resp_msg);
	        	response.sendMessage(sock);
	        	sock.close();
			}
		}
	}
	
	/**
	 *  Data structure to maintain information about SlaveServers
	 *
	 */
	private class SlaveInfo {
		// 64-bit globally unique ID of the SlaveServer
		private long slaveID = -1;
		// Name of the host this SlaveServer is running on
		private String hostName = null;
		// Port which SlaveServer is listening to
		private int port = -1;

		/**
		 * 
		 * @param slaveInfo as "SlaveServerID@HostName:Port"
		 * @throws KVException
		 */
		public SlaveInfo(String slaveInfo) throws KVException {
			// implement me
			String slaveIDString;
			String hostNameString;
			String portNumberString;

			int at = -1;
			int colon = -1;
			if (slaveInfo == null || slaveInfo.isEmpty())
				throw new KVException(new KVMessage("Registration Error: Received unparseable slave information"));
			
			for (int i = 0; i < slaveInfo.length(); i++)
			{
				if (slaveInfo.charAt(i) == '@' && at < 0)
					at = i;
				if (slaveInfo.charAt(i) == ':' && colon < 0)
					colon = i;
			}		
			
			if (at <= 0 || colon <= 0 || colon < at) 
				throw new KVException(new KVMessage("Registration Error: Received unparseable slave information"));
			else {
				slaveIDString = slaveInfo.substring(0, at);
				hostNameString = slaveInfo.substring(at + 1, colon);
				portNumberString = slaveInfo.substring(colon + 1, slaveInfo.length());
				try {
					this.slaveID = Long.parseLong(slaveIDString, 10);
					this.port = Integer.parseInt(portNumberString);
					this.hostName = hostNameString;
				}
				catch (NumberFormatException e) {
					throw new KVException(new KVMessage("Registration Error: Received unparseable slave information"));
				}
			}
		}
		
		public long getSlaveID() {
			return slaveID;
		}
		
		public Socket connectHost() throws KVException {	//added
		    // TODO: Optional Implement Me!
			try {
				Socket s = new Socket(hostName, port);
				s.setSoTimeout(TIMEOUT_MILLISECONDS);
				return s;
			} catch(IOException e){
				throw new KVException(new KVMessage("resp","Network Error: Could not create socket"));
			} catch(Exception e){
				throw new KVException(new KVMessage("resp","Network Error: Could not connect"));
			}
			//return null;
		}
		
		public void closeHost(Socket sock) throws KVException {	//added
		    // TODO: Optional Implement Me!
			try{
				sock.close();
			}
			catch(Exception e){
				throw new KVException(new KVMessage("resp","Network Error: Could not create socket"));
			}
		}
	}
	
	// Timeout value used during 2PC operations
	private static final int TIMEOUT_MILLISECONDS = 5000;
	
	// Cache stored in the Master/Coordinator Server
	private KVCache masterCache = new KVCache(100, 10);
	
	// Registration server that uses TPCRegistrationHandler
	private SocketServer regServer = null;

	// Number of slave servers in the system
	public int numSlaves = -1;
	
	// ID of the next 2PC operation
	private Long tpcOpId = 0L;
	
	/**
	 * Creates TPCMaster
	 * 
	 * @param numSlaves number of expected slave servers to register
	 * @throws Exception
	 */
	public TPCMaster(int numSlaves) {
		// Using SlaveInfos from command line just to get the expected number of SlaveServers 
		this.numSlaves = numSlaves;

		// Create registration server
		regServer = new SocketServer("localhost", 9090);
		regServer.addHandler(new TPCRegistrationHandler());
	}
	
	/**
	 * Calculates tpcOpId to be used for an operation. In this implementation
	 * it is a long variable that increases by one for each 2PC operation. 
	 * 
	 * @return 
	 */
	private String getNextTpcOpId() {
		tpcOpId++;
		return tpcOpId.toString();		
	}
	
	/**
	 * Start registration server in a separate thread
	 */
	public void run() {
		AutoGrader.agTPCMasterStarted();
		// implement me
		
		//regServer.addHandler(new TPCRegistrationHandler());
		
		try {
			regServer.connect();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		Thread t = new Thread(new RunnableWrapper(regServer));
		t.start();
		
		AutoGrader.agTPCMasterFinished();
	}
	
	private class RunnableWrapper implements Runnable {
		
		SocketServer reg = null;
		
		public RunnableWrapper(SocketServer s) {
			reg = s;
		}
		
		public void run() {
			try {
				//System.out.println("reg.run!");
				reg.run();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	
	/**
	 * Converts Strings to 64-bit longs
	 * Borrowed from http://stackoverflow.com/questions/1660501/what-is-a-good-64bit-hash-function-in-java-for-textual-strings
	 * Adapted from String.hashCode()
	 * @param string String to hash to 64-bit
	 * @return
	 */
	private long hashTo64bit(String string) {
		// Take a large prime
		long h = 1125899906842597L; 
		int len = string.length();

		for (int i = 0; i < len; i++) {
			h = 31*h + string.charAt(i);
		}
		return h;
	}
	
	/**
	 * Compares two longs as if they were unsigned (Java doesn't have unsigned data types except for char)
	 * Borrowed from http://www.javamex.com/java_equivalents/unsigned_arithmetic.shtml
	 * @param n1 First long
	 * @param n2 Second long
	 * @return is unsigned n1 less than unsigned n2
	 */
	private boolean isLessThanUnsigned(long n1, long n2) {
		return (n1 < n2) ^ ((n1 < 0) != (n2 < 0));
	}
	
	private boolean isLessThanEqualUnsigned(long n1, long n2) {
		return isLessThanUnsigned(n1, n2) || n1 == n2;
	}	

	/**
	 * Find first/primary replica location
	 * @param key
	 * @return
	 */
	private SlaveInfo findFirstReplica(String key) {
		// 64-bit hash of the key
		long hashedKey = hashTo64bit(key.toString());

		// implement me
		//for(SlaveInfo si:this.slaveList)
			//System.out.print(" "+si.slaveID);
		//System.out.print("\n"+hashedKey);
		SlaveInfo firstSlave = slaveList.get(0);
    	for(int i = 1; i < slaveList.size(); i++)     
    	{
    		if(this.isLessThanEqualUnsigned(hashedKey, slaveList.get(i).getSlaveID())){
    			firstSlave = slaveList.get(i);
    			break;
    		}
    	}
    	return firstSlave;
	}
	
	/**
	 * Find the successor of firstReplica to put the second replica
	 * @param firstReplica
	 * @return
	 */
	private SlaveInfo findSuccessor(SlaveInfo firstReplica) {
		// implement me
		int index=0;
		for (int i=0; i<slaveList.size(); i++)
		{
			if (slaveList.get(i).getSlaveID() == firstReplica.getSlaveID()){
				index = i + 1;
				break;
			}
		}
		if (index == slaveList.size())
			return slaveList.get(0);
		else
			return slaveList.get(index);		
		//return null;
	}
	
	/**
	 * Synchronized method to perform 2PC operations one after another
	 * 
	 * @param msg
	 * @param isPutReq
	 * @return True if the TPC operation has succeeded
	 * @throws KVException
	 */
	public synchronized void performTPCOperation(KVMessage msg, boolean isPutReq) throws KVException {
		AutoGrader.agPerformTPCOperationStarted(isPutReq);
		// implement me
		String key, value, tpcOpId;
		KVMessage prepare, decision, ack1, ack2, abortError;
				
		key = msg.getKey();
		value = msg.getValue();
		tpcOpId = getNextTpcOpId();
				
		//create prepare message
		prepare = new KVMessage(msg.getMsgType()); 
		if (key == null || key.length()<=0)
		throw new KVException(new KVMessage("resp", "Unknown Error: key is null or empty"));
				
		prepare.setKey(key);
		prepare.setTpcOpId(tpcOpId);
		if (isPutReq){
			if (value == null || value.length()<=0)
				throw new KVException(new KVMessage("resp", "Unknown Error: value is null or empty"));
			prepare.setValue(value);
		}

		//send prepare to the first slaveServer
		SlaveInfo firstSlave = findFirstReplica(key);
		//System.out.println("first slave: "+firstSlave.slaveID);
		Socket socket1 = firstSlave.connectHost();
		try{prepare.sendMessage(socket1);}
		catch(KVException e){		//can not connect to slaver server
			throw new KVException(new KVMessage("resp", e.getMsg().getMessage()));
		}
		//send prepare to the second slaveServer
		SlaveInfo secondSlave = findSuccessor(firstSlave);
		//System.out.println("Successor slave: "+secondSlave.slaveID);
		Socket socket2 = secondSlave.connectHost();	//changed
		try{prepare.sendMessage(socket2);}
		catch(KVException e){		//can not connect to slaver server
			throw new KVException(new KVMessage("resp", e.getMsg().getMessage()));
		}

		//get response
		InputStream in1 = null;
		try {socket1.setSoTimeout(TIMEOUT_MILLISECONDS);} 
		catch (Exception e) {}
				
		InputStream in2 = null;
		try {socket2.setSoTimeout(TIMEOUT_MILLISECONDS);}
		catch (Exception e) {}
				
		KVMessage response1 = null;	
		KVMessage response2 = null;
		try{
			in1 = socket1.getInputStream();
		    response1 = new KVMessage(in1);
		}catch(Exception e){
			response1 = null;
		}
		try{
            in2 = socket2.getInputStream();
            response2 = new KVMessage(in2);
		}catch(Exception e){
			response2 = null;
		}
		//create decision
		abortError = null;
		decision = null;
		if (response1 == null || response2 == null)
		{
			decision = new KVMessage("abort", tpcOpId);
			String errorMessage1="";
			String errorMessage2="";
			if(response1 == null)
				errorMessage1 = "@"+firstSlave.getSlaveID()+":=" + "slave server is down" +"\\n";
			if(response2 == null)
				errorMessage2 = "@"+secondSlave.getSlaveID()+":=" + "slave server is down"; 
			abortError = new KVMessage("resp", errorMessage1+errorMessage2);
		}
		//else if (response1.getMsgType() == "ready" && response2.getMsgType() == "ready")
		else if (response1.getMsgType().equals("ready") && response2.getMsgType().equals("ready"))
			decision = new KVMessage("commit", tpcOpId);
		
		else if (response1.getMsgType().equals("abort") && response2.getMsgType().equals("abort")){
			decision = new KVMessage("abort", tpcOpId);
			String errorMessage1 = "@"+firstSlave.getSlaveID()+":=" + response1.getMessage() +"\\n";
			String errorMessage2 = "@"+secondSlave.getSlaveID()+":=" + response2.getMessage(); 
			abortError = new KVMessage("resp", errorMessage1+errorMessage2);
		
		}else if (response1.getMsgType().equals("abort") && response2.getMsgType().equals("ready")){
			decision = new KVMessage("abort", tpcOpId);
			String errorMessage1 = "@"+firstSlave.getSlaveID()+":=" + response1.getMessage();
			abortError = new KVMessage("resp", errorMessage1);
		
		}else if (response1.getMsgType().equals("ready") && response2.getMsgType().equals("abort")){
			decision = new KVMessage("abort", tpcOpId);
			String errorMessage2 = "@"+secondSlave.getSlaveID()+":=" + response2.getMessage(); 
			abortError = new KVMessage("resp", errorMessage2);
		}
		
		try {
			socket1.close();
			socket2.close();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		//socket1 = firstSlave.connectHost();
		//socket2 = secondSlave.connectHost();
		//send decision and get ack back
		ack1 = null;
		ack2 = null;
		
		//int deb_counter=0;
		//KVMessage crash = new KVMessage("ignoreNext");
		//crash.sendMessage(socket2);
		//secondSlave.closeHost(socket2);
		while (ack1 == null || ack2 == null){
		try {
				if(ack1==null)
				{
					socket1 = firstSlave.connectHost();
					decision.sendMessage(socket1);
					socket1.setSoTimeout(TIMEOUT_MILLISECONDS);
					ack1 = new KVMessage(socket1.getInputStream());
				}
				if(ack2==null)
				{
					socket2 = secondSlave.connectHost();
					decision.sendMessage(socket2);
					socket2.setSoTimeout(TIMEOUT_MILLISECONDS);
					ack2 = new KVMessage(socket2.getInputStream());
				}
			} catch (Exception e) {
				//ack1 = null;
				//ack2 = null;
				//deb_counter++;
//				if(deb_counter<=10000)
//				{
//					crash.sendMessage(socket2);
//					System.out.println(deb_counter);
//				}
				//System.out.println("cant do");
				
			}
		}

		if (ack1.getMsgType().equals("ack") && ack2.getMsgType().equals("ack")){
			if(response1==null||response2==null)
				throw new KVException(abortError);
			if (response1!= null && response1.getMsgType().equals("abort"))//{
				throw new KVException(abortError);
			if (response2 != null && response2.getMsgType().equals("abort"))
				throw new KVException(abortError);
//			if (response1.getMsgType().equals("abort") || response2.getMsgType().equals("abort"))//{
//				throw new KVException(abortError);
			/*}else{
		                if (isPutReq)
		                    this.masterCache.put(key, value);
		                else
		                    this.masterCache.del(key);
			}*/
		}
		
		firstSlave.closeHost(socket1); 
		secondSlave.closeHost(socket2); 
		
		AutoGrader.agPerformTPCOperationFinished(isPutReq);
	}

	/**
	 * Perform GET operation in the following manner:
	 * - Try to GET from first/primary replica
	 * - If primary succeeded, return Value
	 * - If primary failed, try to GET from the other replica
	 * - If secondary succeeded, return Value
	 * - If secondary failed, return KVExceptions from both replicas
	 * 
	 * @param msg Message containing Key to get
	 * @return Value corresponding to the Key
	 * @throws KVException
	 */
	public String handleGet(KVMessage msg) throws KVException {
		AutoGrader.aghandleGetStarted();
		// implement me
		
		String key = msg.getKey();
		String value1 = masterCache.get(key);
		String value2 = null;
		if(value1 != null){
			AutoGrader.aghandleGetFinished();
			return value1;
		}
		
		SlaveInfo firstSlave = findFirstReplica(key);
		SlaveInfo successorSlave = findSuccessor(firstSlave);
		        
		KVMessage getRequest = new KVMessage("getreq", key);//key not share here,need change to final
		Socket s1 = firstSlave.connectHost();
		//firstSlave.closeHost(s1);
		getRequest.sendMessage(s1);  //wrong
		KVMessage response1 = null;
		try{
			//System.out.println("----------");
			response1 = new KVMessage(s1.getInputStream());  //wrong
			//System.out.println(response1.toXML());
		}catch(Exception e){
			response1 = null;
		}
	
		if (response1 != null && response1.getValue() != null){
			value1 = response1.getValue(); //value1 not share here, need final
		}
		if(value1!=null)
		{
			AutoGrader.aghandleGetFinished();
			return value1;
		}
		
		getRequest = new KVMessage("getreq", key);//key not share here,need change to final
		Socket s2 = successorSlave.connectHost();
		getRequest.sendMessage(s2);  //wrong
		KVMessage response2 = null;
		try{
			response2 = new KVMessage(s2.getInputStream());  //wrong
		}catch(Exception e){
			response2 = null;
		}
	
		if (response2!=null && response2.getValue() != null){
			value2 = response2.getValue(); //value1 not share here, need final
		}
		if(value2!=null)
		{
			AutoGrader.aghandleGetFinished();
			return value2;
		}
	
	
		KVMessage error_info = null;
		if(response1 != null && response2 != null)
		{
			error_info = new KVMessage("resp","Dose not exist");
			throw new KVException(error_info);
		}
		String error_message1="";
		String error_message2="";
		if(response1 == null && response2!=null){
			error_message1 = "@"+firstSlave.getSlaveID()+":="+"Unkown Error: key was not found";
			error_info = new KVMessage("resp",error_message1);
		}
		if(response2 == null && response1 != null)
		{
			error_message2 = "@"+successorSlave.getSlaveID()+":="+"Unkown Error: key was not found";
			error_info = new KVMessage("resp",error_message2);
		}
		if (response1==null && response2==null){
			error_message1 = error_message1 + "\n" + error_message2;
			error_info = new KVMessage("resp",error_message1);
		}
		
		throw new KVException(error_info);
		//return "Unkown Error: key was not found";
		
		
	}
}
