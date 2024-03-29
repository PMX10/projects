/**
 * Slave Server component of a KeyValue store
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

import java.util.concurrent.locks.Lock;

/**
 * This class defines the slave key value servers. Each individual KVServer 
 * would be a fully functioning Key-Value server. For Project 3, you would 
 * implement this class. For Project 4, you will have a Master Key-Value server 
 * and multiple of these slave Key-Value servers, each of them catering to a 
 * different part of the key namespace.
 *
 */
public class KVServer implements KeyValueInterface {
	private KVStore dataStore = null;
	private KVCache dataCache = null;
	
	private static final int MAX_KEY_SIZE = 256;
	private static final int MAX_VAL_SIZE = 256 * 1024;
	
	/**
	 * @param numSets number of sets in the data Cache.
	 */
	public KVServer(int numSets, int maxElemsPerSet) {
		dataStore = new KVStore();
		dataCache = new KVCache(numSets, maxElemsPerSet);

		AutoGrader.registerKVServer(dataStore, dataCache);
	}
	
	private void validate(String op, String key, String value) throws KVException{
		if (key == null || key.length() <= 0)
			throw new KVException(new KVMessage("resp", "Unknown Error: key is null or empty"));
		if (key.length() > MAX_KEY_SIZE)
			throw new KVException(new KVMessage("resp", "Oversized key"));
		
		if (op == "put"){
		if (value == null || value.length() <= 0)
			throw new KVException(new KVMessage("resp", "Unknown Error: value is null or empty"));
		if (value.length() > MAX_VAL_SIZE)
			throw new KVException(new KVMessage("resp", "Oversized value"));
		}
		
	}
	
	public void put(String key, String value) throws KVException {
		// Must be called before anything else
		AutoGrader.agKVServerPutStarted(key, value);

		validate("put", key, value);
		Lock setLock = dataCache.getWriteLock(key);
			
		setLock.lock();
		// Put key/value in the store and the cache
		dataCache.put(key, value);
		dataStore.put(key, value);
		setLock.unlock();
		
		// Must be called before return or abnormal exit
		AutoGrader.agKVServerPutFinished(key, value);
	}
	
	public String get (String key) throws KVException {
		// Must be called before anything else
		AutoGrader.agKVServerGetStarted(key);
		
		validate("get", key, null);
		
		String value;
		Lock setLock = dataCache.getWriteLock(key);
		
		setLock.lock();
		value = dataCache.get(key);
		if (value == null){		//if not value in cache, access file system
			try{
			value = dataStore.get(key);
			}
			catch(KVException e)
			{
				throw new KVException(new KVMessage("resp","Does not exist"));
			}
			dataCache.put(key, value);
		}
	
		setLock.unlock();
		
		// Must be called before return or abnormal exit
		AutoGrader.agKVServerGetFinished(key);
		return value;
	}
	
	public void del (String key) throws KVException {
		// Must be called before anything else
		AutoGrader.agKVServerDelStarted(key);

		validate("del", key, null);
		
		Lock setLock = dataCache.getWriteLock(key);
		setLock.lock();
		try{
		dataStore.get(key);
		}
		catch(KVException e)
		{
			throw new KVException(new KVMessage("resp","Does not exist"));
		}
		//dataCache.del(key);
		dataStore.del(key);
		dataCache.del(key);
		setLock.unlock();

		// Must be called before return or abnormal exit
		AutoGrader.agKVServerDelFinished(key);
	}
	/*public static void main(String arg[])
	{
			KVServer kvs = new KVServer(100,10);
			try {
				kvs.put("1", "a");
				kvs.put("1", "b");
				System.out.println(kvs.get("1"));
				//kvs.put("2","c");
				kvs.del("1");
				//System.out.println(kvs.get("1"));
				//kvs.get("1");
				System.out.println("!!!!!!!!!");
				//kvs.del("2");
				System.out.println("dataCache size: "+kvs.dataCache.size_t());
				System.out.println("dataStore size: "+kvs.dataStore.size_t());
				//System.out.print(kvs.get("1"));
			} catch (KVException e) {
				// TODO Auto-generated catch block
				System.out.print(e.getMsg().getMessage());
			}
	}*/
}
