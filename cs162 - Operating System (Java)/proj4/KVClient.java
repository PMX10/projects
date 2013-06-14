/**
 * Client component for generating load for the KeyValue store. 
 * This is also used by the Master server to reach the slave nodes.
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
import java.net.Socket;


/**
 * This class is used to communicate with (appropriately marshalling and unmarshalling) 
 * objects implementing the {@link KeyValueInterface}.
 *
 */
public class KVClient implements KeyValueInterface {

	private String server = null;
	private int port = 0;
	
	String returnValue = null;
	
	/**
	 * @param server is the DNS reference to the Key-Value server
	 * @param port is the port on which the Key-Value server is listening
	 */
	public KVClient(String server, int port) {
		this.server = server;
		this.port = port;
	}
	
	private Socket connectHost() throws KVException {
	    // TODO: Implement Me!  
		try {
			return new Socket(server, port);
		} catch(IOException e){
			throw new KVException(new KVMessage("resp","Network Error: Could not create socket"));
		} catch(Exception e){
			throw new KVException(new KVMessage("resp","Network Error: Could not connect"));
		}
	}
	
	private void closeHost(Socket sock) throws KVException {
	    // TODO: Implement Me!
		try{
			sock.close();
		}
		catch(Exception e){
			throw new KVException(new KVMessage("resp","Network Error: Could not create socket"));
		}
	}
	
	public void put(String key, String value) throws KVException {
	    // TODO: Implement Me from Project 3
		operation("putreq", key, value);
	}

	public String get(String key) throws KVException {
		// TODO: Implement Me from Project 3
		operation("getreq", key, null);
		return returnValue;
	}
	
	public void del(String key) throws KVException {
		// TODO: Implement Me from Project 3
		operation("delreq", key, null);
	}	
	
	public void operation(String op, String key, String value) throws KVException {
		//create a new socket
		Socket sock = connectHost();
		KVMessage message = null;
		//generate a KVMessage and send to server
		if (value == null)
			message = new KVMessage(op, key);
		else 
			message = new KVMessage(op,key, value);
		message.sendMessage(sock);
		
		//shut down output
//		try {
//			sock.shutdownOutput();
//		} catch (Exception e) {
//			throw new KVException(new KVMessage("resp","Unknown Error: Could not shut down Output"));
//		}
		
		//sock = connectHost();
		//get response from server
		KVMessage response = null;
		try {
			InputStream in = sock.getInputStream();
			response = new KVMessage(in);
		} catch(Exception e){
			throw new KVException(new KVMessage("resp","Network Error: Could not receive data"));
		}
		
		//close server
		closeHost(sock);
		
		//validates response
		if (op.equals("getreq")){	// set return value if operation s "get"
			if(response.getValue() != null)
				this.returnValue = response.getValue();
			else
				throw new KVException(new KVMessage("resp", response.getMessage()));
		}
		else
		{ 
			if(!response.getMessage().equals("Success"))
				throw new KVException(new KVMessage("resp", response.getMessage()));
		}
	}
	
	public void ignoreNext() throws KVException {
	    // TODO: Implement Me!
		//create a new socket
		Socket sock = connectHost();
		KVMessage message = new KVMessage("ignoreNext");
		message.sendMessage(sock);
				
		//shut down output
		/*try {
			sock.shutdownOutput();
		} catch (Exception e) {
			throw new KVException(new KVMessage("resp","Unknown Error: Could not shut down Output"));
		}*/
				
		//get response from server
		KVMessage response = null;
		try {
			InputStream in = sock.getInputStream();
			response = new KVMessage(in);
		} catch(Exception e){
			throw new KVException(new KVMessage("resp","Network Error: Could not receive data"));
		}
				
		//close server
		closeHost(sock);
		
		if (!response.getMsgType().equals("resp"))
			throw new KVException(new KVMessage("resp","Unknown Error: Received message format incorrect"));
		if (response.getMessage() == null)
			throw new KVException(new KVMessage("resp","Unknown Error: Received message format incorrect"));
		if (!response.getMessage().equals("Success"))
			throw new KVException(response);
	}
}
