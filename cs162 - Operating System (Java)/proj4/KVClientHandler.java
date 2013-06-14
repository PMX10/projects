/**
 * Handle client connections over a socket interface
 * 
 * @author Mosharaf Chowdhury (http://www.mosharaf.com)
 * @author Prashanth Mohan (http://www.cs.berkeley.edu/~prmohan)
 *
 * Copyright (c) 2011, University of California at Berkeley
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
 *  DISCLAIMED. IN NO EVENT SHALL PRASHANTH MOHAN BE LIABLE FOR ANY
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
import java.net.Socket;

/**
 * This NetworkHandler will asynchronously handle the socket connections. 
 * It uses a threadpool to ensure that none of it's methods are blocking.
 *
 */
public class KVClientHandler implements NetworkHandler {
	private ThreadPool threadpool = null;
    private TPCMaster tpcMaster = null;
	
	public KVClientHandler(TPCMaster tpcMaster) {
		initialize(1, tpcMaster);
	}

	public KVClientHandler(int connections, TPCMaster tpcMaster) {
		initialize(connections, tpcMaster);
	}

	private void initialize(int connections, TPCMaster tpcMaster) {
		threadpool = new ThreadPool(connections);
        this.tpcMaster = tpcMaster; 
	}
	

	private class ClientHandler implements Runnable {
		private Socket client = null;
		
		@Override
		public void run() {
			try
			 {
				InputStream input = client.getInputStream();
				NoCloseInputStream is = new NoCloseInputStream(input);
				KVMessage request = new KVMessage(is);
				KVMessage response = new KVMessage("resp");
				//System.out.println(request.getMsgType());
				String key = null;
				String value = null;
				boolean validRequest = false;
				// Get request
				if (request.getMsgType().compareTo("getreq") == 0)
				{
					validRequest = true;
					key = request.getKey();
					value = tpcMaster.handleGet(request);
					//response.setKey(key);
					response.setValue(value);
					response.setMessage("Success");
					//System.out.println(response.getValue());
				}
				// Put request
				if (request.getMsgType().compareTo("putreq") == 0)
				{
					validRequest = true;
					key = request.getKey();
					value = request.getValue();
					tpcMaster.performTPCOperation(request, true);
					response.setMessage("Success");
				}
				// Delete request
				if (request.getMsgType().compareTo("delreq") == 0)
				{
					validRequest = true;
					tpcMaster.performTPCOperation(request, false);
					response.setMessage("Success");
				}
				// Not a valid request
				if (!validRequest)
				{
					KVMessage err = new KVMessage("resp", "Unknown Error: Not a valid request");
					throw new KVException(err);
				}
				// Send response back to client
				response.sendMessage(client);
			 }
			 catch (KVException e)
			 {
				try
				{
					e.getMsg().sendMessage(client);
				//String errResponse;
				//errResponse = e.getMsg().toXML();
				//client.getOutputStream().write(errResponse.getBytes());
				//client.shutdownOutput();
				}
				catch (KVException err)
				{
				}
			 } 
			 catch (IOException err)
			 {
			 }
		}
		
		public ClientHandler(Socket client) {
			this.client = client;
		}
	}
	
	/* (non-Javadoc)
	 * @see edu.berkeley.cs162.NetworkHandler#handle(java.net.Socket)
	 */
	@Override
	public void handle(Socket client) throws IOException {
		Runnable r = new ClientHandler(client);
		try {
			//System.out.println("+++++++++++++");
			threadpool.addToQueue(r);
		} catch (InterruptedException e) {
			// Ignore this error
			return;
		}
	}
	private class NoCloseInputStream extends FilterInputStream {
	    public NoCloseInputStream(InputStream in) {
	        super(in);
	    }
	    
	    public void close() {} // ignore close
	}
}
