/**
 * Log for Two-Phase Commit
 * 
 * @author Mosharaf Chowdhury (http://www.mosharaf.com)
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
 *  DISCLAIMED. IN NO EVENT SHALL PRASHANTH MOHAN BE LIABLE FOR ANY
 *  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package edu.berkeley.cs162;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.*;

public class TPCLog {

	// Path to log file
	private String logPath = null;
	// Reference to the KVServer of this slave. Populated by rebuildKeyServer()
	private KVServer kvServer = null;

	// Log entries
	private ArrayList<KVMessage> entries = null;
	
	/*  Keeps track of the interrupted 2PC operation.
	 There can be at most one, i.e., when the last 2PC operation before
	 crashing was in READY state.
	 Set in  rebuildKeyServer() during recovery */ 
	private KVMessage interruptedTpcOperation = null;
	
	/**
	 * 
	 * @param logPath 
	 * @param kvServer Reference to the KVServer of this slave. Populated by
	 * rebuildKeyServer() during start. 
	 */
	public TPCLog(String logPath, KVServer kvServer) {
		this.logPath = logPath;
		entries = null;
		this.kvServer = kvServer;
	}

	public ArrayList<KVMessage> getEntries() {
		return entries;
	}

	public boolean empty() {
		return (entries.size() == 0);
	}
	
	public void appendAndFlush(KVMessage entry) {
		// implement me
		if (entries == null) {
			entries = new ArrayList <KVMessage> ();
		}
		entries.add(entry);    // Append to the ArrayList of KVMessage objects
		flushToDisk();    // Writes the ArrayList data to disk
	}

	/**
	 * Load log from persistent storage
	 */
	@SuppressWarnings("unchecked")
	public void loadFromDisk() {
		ObjectInputStream inputStream = null;
		
		try {
			inputStream = new ObjectInputStream(new FileInputStream(logPath));			
			entries = (ArrayList<KVMessage>) inputStream.readObject();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// If log never existed, there are no entries
			if (entries == null) {
				entries = new ArrayList<KVMessage>();
			}

			try {
				if (inputStream != null) {
					inputStream.close();
				}
			} catch (IOException e) {				
				e.printStackTrace();
			}
		}
	}
	
	/**
	 * Writes log to persistent storage
	 */
	public void flushToDisk() {
		ObjectOutputStream outputStream = null;
		
		try {
			outputStream = new ObjectOutputStream(new FileOutputStream(logPath));
			outputStream.writeObject(entries);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (outputStream != null) {
					outputStream.flush();
					outputStream.close();
				}
			} catch (IOException e) {				
				e.printStackTrace();
			}
		}
	}
	
	/**
	 * Load log and rebuild by iterating over log entries
	 * Set interruptedTpcOperation, if there is one (i.e., SlaveServer crashed
	 * in the READY state)
	 * @throws KVException
	 */
	public void rebuildKeyServer() throws KVException {
		// implement me
		try {
			FileInputStream fis = new FileInputStream(logPath);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			return;
		}
		loadFromDisk();
		HashMap<String,KVMessage> hm = new HashMap<String,KVMessage>();
		KVMessage retrive_meg = null;
		for(KVMessage entry:entries)
		{
			if(!hm.containsKey(entry.getTpcOpId()))
			{
				hm.put(entry.getTpcOpId(), entry);
			}
			else
			{
				retrive_meg = hm.remove(entry.getTpcOpId());
				if(entry.getMsgType().equals("commit"))
				{
					if(retrive_meg.getMsgType().equals("putreq"))
					{
						kvServer.put(retrive_meg.getKey(), retrive_meg.getValue());
					}
					else if(retrive_meg.getMsgType().equals("delreq"))			
					{
						kvServer.del(retrive_meg.getKey());
					}
				}
				else if(retrive_meg.getMsgType().equals("commit"))
				{
					if(entry.getMsgType().equals("putreq"))
					{
						kvServer.put(entry.getKey(), entry.getValue());
					}
					else if(entry.getMsgType().equals("delreq"))			
					{
						kvServer.del(entry.getKey());
					}
				}
			}
		}
//		for (int i = 0; i < entries.size(); i++) {
//			// Put request
//			KVMessage entry = entries.get(i);
//			KVMessage entry2 = null;
//			if(i<entries.size()-1)
//				entry2 = entries.get(i+1);
//			if (entry.getMsgType().equals("putreq") && entry2!=null && entry2.getMsgType().equals("commit"))
//			{
//				kvServer.put(entry.getKey(), entry.getValue());
//			}
//			// Delete request
//			if (entry.getMsgType().equals("delreq") && entry2!=null && entry2.getMsgType().equals("commit")) {
//				kvServer.del(entry.getKey());
//			}
//			// Operation put in Ready state
//		}
		//String last_op_type = entries.get(entries.size()-1).getMsgType();
		for(String k: hm.keySet())
			if(!hm.get(k).getMsgType().equals("commit")&&!hm.get(k).getMsgType().equals("abort"))
			{
				interruptedTpcOperation = hm.get(k);
				break;
			}
		
		// Server crashed while 2PC operation was in Ready state
	}
	
	/**
	 * 
	 * @return Interrupted 2PC operation, if any 
	 */
	public KVMessage getInterruptedTpcOperation() { 
		KVMessage logEntry = interruptedTpcOperation; 
		interruptedTpcOperation = null; 
		return logEntry; 
	}
	
	/**
	 * 
	 * @return True if TPCLog contains an interrupted 2PC operation
	 */
	public boolean hasInterruptedTpcOperation() {
		return interruptedTpcOperation != null;
	}
}
