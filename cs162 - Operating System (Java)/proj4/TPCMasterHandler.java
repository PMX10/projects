/**
 * Handle TPC connections over a socket interface
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

import java.io.FilterInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.InetAddress;
import java.net.Socket;
import java.net.UnknownHostException;

/**
 * Implements NetworkHandler to handle 2PC operation requests from the Master/
 * Coordinator Server
 *
 */
public class TPCMasterHandler implements NetworkHandler {
	
	//added phase to indicate which phase
	private int phase = 1;
	
	private KVServer kvServer = null;
	private ThreadPool threadpool = null;
	private TPCLog tpcLog = null;
	
	private long slaveID = -1;
	
	// Used to handle the "ignoreNext" message
	private boolean ignoreNext = false;
	
	// States carried from the first to the second phase of a 2PC operation
	private KVMessage originalMessage = null;
	private boolean aborted = true;	

	public TPCMasterHandler(KVServer keyserver) {
		this(keyserver, 1);
	}

	public TPCMasterHandler(KVServer keyserver, long slaveID) {
		this.kvServer = keyserver;
		this.slaveID = slaveID;
		threadpool = new ThreadPool(1);
	}

	public TPCMasterHandler(KVServer kvServer, long slaveID, int connections) {
		this.kvServer = kvServer;
		this.slaveID = slaveID;
		threadpool = new ThreadPool(connections);
	}

	private class ClientHandler implements Runnable {
		private KVServer keyserver = null;
		private Socket client = null;
		
		private void closeConn() {
			try {
				client.close();
			} catch (IOException e) {
			}
		}
		
		@Override
		public void run() {
			// Receive message from client
			// Implement me
			KVMessage msg = null;
			
			InputStream input = null;
			try {
				input = client.getInputStream();
			} catch (IOException e) {
				e.printStackTrace();
			}
			
			NoCloseInputStream is = new NoCloseInputStream(input);
			
			try {
				msg = new KVMessage(is);
			} catch (KVException e) {
				try {
					e.getMsg().sendMessage(client);
				} catch (KVException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
			
			// Parse the message and do stuff 
			String key = msg.getKey();
			
			try {
				
			if (msg.getMsgType().equals("putreq")) {
				//System.out.println("puttttt");
					tpcLog.appendAndFlush(msg);
					handlePut(msg, key);
			}
			else if (msg.getMsgType().equals("getreq")) {
				handleGet(msg, key);
			}
			else if (msg.getMsgType().equals("delreq")) {
				tpcLog.appendAndFlush(msg);
				handleDel(msg, key);
			} 
			else if (msg.getMsgType().equals("ignoreNext")) {
				// Set ignoreNext to true. PUT and DEL handlers know what to do.
				// Implement me
				
				// Send back an acknowledgment
				// Implement me
				
				tpcLog.appendAndFlush(msg);
				ignoreNext = true;
				KVMessage response = new KVMessage("resp", "Success");
				response.setTpcOpId(msg.getTpcOpId());
				response.sendMessage(client);
			}
			else if (msg.getMsgType().equals("commit") || msg.getMsgType().equals("abort")) {
				// Check in TPCLog for the case when SlaveServer is restarted
				// Implement me
				tpcLog.appendAndFlush(msg);
				handleMasterResponse(msg, originalMessage, aborted);
	
				// Reset state
				// Implement me
				originalMessage = null;
				aborted = true;
				phase = 1;
			}
			}//try
			catch (KVException e) {
				try {
					e.getMsg().sendMessage(client);
				} catch (KVException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
			// Finally, close the connection
			closeConn();
		}

		private void handlePut(KVMessage msg, String key) throws KVException{
			handlePutAndDel(msg, key, true);
		}
		
 		private void handleGet(KVMessage msg, String key) throws KVException{
 			AutoGrader.agGetStarted(slaveID);
			
 			// Implement me
 			String value;
			value = keyserver.get(key);
			KVMessage response = new KVMessage("resp");
	 		response.setKey(key);
	 		response.setValue(value);
	 		response.sendMessage(client);
						
 			AutoGrader.agGetFinished(slaveID);
		}
		
		private void handleDel(KVMessage msg, String key) throws KVException{
			handlePutAndDel(msg, key, false);
		}
		
		private void handlePutAndDel(KVMessage msg, String key, boolean isPut) throws KVException{
			AutoGrader.agTPCPutStarted(slaveID, msg, key);
			// Store for use in the second phase
			originalMessage = new KVMessage(msg);
			KVMessage response = null;
				
			if(phase == 1){
				if(ignoreNext == true){
					ignoreNext = false;
					response = new KVMessage("abort");
					response.setMessage("IgnoreNext Error: SlaveServer " + slaveID +" has ignored this 2PC request during the first phase");
				}//end if ignorenext
				else{
					boolean abort = false;
					String v=null;
					if (!isPut){
						//try to get the key to see if the key exist, if exist, resp ready, abort otherwise
						try{
							v = keyserver.get(key);
						}catch (KVException e){
							abort = true;
						}
					
						if (abort || v==null){
							response = new KVMessage("abort");
							response.setMessage("Key does not exist in server: " + slaveID);
					 	}
						else 
							response = new KVMessage("ready");
					}
					else 
						response = new KVMessage("ready");
					//change the phase		
					phase = 2;
				}
			}//end if phase 1
			else{
				if(aborted == false){
					if (isPut){
						String value = originalMessage.getValue();
						keyserver.put(key, value);
					}
					else 
						keyserver.del(key);
					response = new KVMessage("ack");
				}//end if aborted
			}
			response.setTpcOpId(originalMessage.getTpcOpId());
			response.sendMessage(client);
			AutoGrader.agTPCPutFinished(slaveID, msg, key);
		}

		/**
		 * Second phase of 2PC
		 * 
		 * @param masterResp Global decision taken by the master
		 * @param origMsg Message from the actual client (received via the coordinator/master)
		 * @param origAborted Did this slave server abort it in the first phase 
		 */
		private void handleMasterResponse(KVMessage masterResp, KVMessage origMsg, boolean origAborted) throws KVException{
			AutoGrader.agSecondPhaseStarted(slaveID, origMsg, origAborted);
			
			// Implement me
			if (tpcLog.hasInterruptedTpcOperation()){
				origMsg = tpcLog.getInterruptedTpcOperation();
				originalMessage = origMsg;
				phase = 2;
			}
			if(masterResp.getMsgType().equals("commit"))
			{
				aborted = false;
				if(origMsg.getMsgType().equals("putreq"))
					handlePut(origMsg, origMsg.getKey());
				
				if(origMsg.getMsgType().equals("delreq"))
					handleDel(origMsg,origMsg.getKey());
			}
			else{
				//receive an abort from master/coordinator. Do nothing
				KVMessage response = new KVMessage("ack");
				response.setTpcOpId(origMsg.getTpcOpId());
				response.sendMessage(client);
			}
			
			AutoGrader.agSecondPhaseFinished(slaveID, origMsg, origAborted);
		}

		public ClientHandler(KVServer keyserver, Socket client) {
			this.keyserver = keyserver;
			this.client = client;
		}
	}

	@Override
	public void handle(Socket client) throws IOException {
		AutoGrader.agReceivedTPCRequest(slaveID);
		Runnable r = new ClientHandler(kvServer, client);
		try {
			threadpool.addToQueue(r);
		} catch (InterruptedException e) {
			// TODO: HANDLE ERROR
			return;
		}		
		AutoGrader.agFinishedTPCRequest(slaveID);
	}

	/**
	 * Set TPCLog after it has been rebuilt
	 * @param tpcLog
	 */
	public void setTPCLog(TPCLog tpcLog) {
		this.tpcLog  = tpcLog;
	}

	/**
	 * Registers the slave server with the coordinator
	 * 
	 * @param masterHostName
	 * @param servr KVServer used by this slave server (contains the hostName and a random port)
	 * @throws UnknownHostException
	 * @throws IOException
	 * @throws KVException
	 */
	public void registerWithMaster(String masterHostName, SocketServer server) throws UnknownHostException, IOException, KVException {
		AutoGrader.agRegistrationStarted(slaveID);
		
		Socket master = new Socket(masterHostName, 9090);
		KVMessage regMessage = new KVMessage("register", slaveID + "@" + server.getHostname() + ":" + server.getPort());
		regMessage.sendMessage(master);
		
		// Receive master response. 
		// Response should always be success, except for Exceptions. Throw away.
		new KVMessage(master.getInputStream());
		
		master.close();
		AutoGrader.agRegistrationFinished(slaveID);
	}
	
	private class NoCloseInputStream extends FilterInputStream {
	    public NoCloseInputStream(InputStream in) {
	        super(in);
	    }

	    public void close() {} // ignore close
	}
}
