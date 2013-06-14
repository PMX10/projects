/*
 * 
 * Implementation of a set-associative cache.
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

import java.util.concurrent.locks.ReentrantReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock.WriteLock;

import java.io.StringWriter;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.w3c.dom.Text;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;


/**
 * A set-associate cache which has a fixed maximum number of sets (numSets).
 * Each set has a maximum number of elements (MAX_ELEMS_PER_SET).
 * If a set is full and another entry is added, an entry is dropped based on the eviction policy.
 */
public class KVCache implements KeyValueInterface {	
	private int numSets = 100;
	private int maxElemsPerSet = 10;
		
	private CacheSet[] sets;
    private ReentrantReadWriteLock[] locks;
    
	/**
	 * Creates a new LRU cache.
	 * @param cacheSize	the maximum number of entries that will be kept in this cache.
	 */
	public KVCache(int numSets, int maxElemsPerSet) {
		this.numSets = numSets;
		this.maxElemsPerSet = maxElemsPerSet;     
		
		sets = new CacheSet[this.numSets];
        locks = new ReentrantReadWriteLock[this.numSets];
        
        for (int i = 0; i < this.numSets; i++) {
            sets[i] = new CacheSet(this.maxElemsPerSet);
            locks[i] = new ReentrantReadWriteLock();
        }
	}

	/**
	 * Retrieves an entry from the cache.
	 * Assumes the corresponding set has already been locked for writing.
	 * @param key the key whose associated value is to be returned.
	 * @return the value associated to this key, or null if no value with this key exists in the cache.
	 */
	public String get(String key) throws KVException{
		// Must be called before anything else
		AutoGrader.agCacheGetStarted(key);
		AutoGrader.agCacheGetDelay();
        
		if ((key == null) || (key.length() <= 0)) {
            throw new KVException(new KVMessage("resp", "Unknown Error: Key cannont be empty!"));
        }
        
		//get result from the CacheSet
        String result = sets[getSetId(key)].getInCache(key);
		
		// Must be called before returning
		AutoGrader.agCacheGetFinished(key);
		return result;
	}

	/**
	 * Adds an entry to this cache.
	 * If an entry with the specified key already exists in the cache, it is replaced by the new entry.
	 * If the cache is full, an entry is removed from the cache based on the eviction policy
	 * Assumes the corresponding set has already been locked for writing.
	 * @param key	the key with which the specified value is to be associated.
	 * @param value	a value to be associated with the specified key.
	 * @return true is something has been overwritten 
	 */
	public void put(String key, String value) throws KVException {
		// Must be called before anything else
		AutoGrader.agCachePutStarted(key, value);
		AutoGrader.agCachePutDelay();

		if ((key == null) || (key.length() <= 0)) {
            throw new KVException(new KVMessage("resp", "Unknown Error: Key cannot be empty!"));
        } else if (key.length() > 256) { // key is larger than 256B
            throw new KVException(new KVMessage("resp","Oversized key"));
        } else if ((value == null) || (value.length() <= 0)) {
            throw new KVException(new KVMessage("resp", "Unknown Error: Value cannot be empty!"));
        } else if (value.length() > 262144) { // value is larger than 256KB
            throw new KVException(new KVMessage("resp", "Oversized value"));
        }
        
        sets[getSetId(key)].putInCache(key, value);
		
		// Must be called before returning
		AutoGrader.agCachePutFinished(key, value);
	}

	/**
	 * Removes an entry from this cache.
	 * Assumes the corresponding set has already been locked for writing.
	 * @param key	the key with which the specified value is to be associated.
	 */
	public void del (String key) throws KVException {
		// Must be called before anything else
		AutoGrader.agCacheGetStarted(key);
		AutoGrader.agCacheDelDelay();
		
		if ((key == null) || (key.length() <= 0)) {
            throw new KVException(new KVMessage("resp", "Unknown Error: Key cannont be empty!"));
        }
        
		//get result from the CacheSet
        sets[getSetId(key)].delInCache(key);
		
		// Must be called before returning
		AutoGrader.agCacheDelFinished(key);
	}
	
	/**
	 * @param key
	 * @return	the write lock of the set that contains key.
	 */
	public WriteLock getWriteLock(String key) {
		return locks[this.getSetId(key)].writeLock();
	}
	
	/**
	 * 
	 * @param key
	 * @return	set of the key
	 */
	private int getSetId(String key) {
		return (key.hashCode() & 0x7FFFFFFF) % numSets;
	}
	
    public String toXML() throws Exception{
    	DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
    	DocumentBuilder db = null;
    	try {
            db = dbFactory.newDocumentBuilder();
        } catch (ParserConfigurationException e1) {
        	System.out.print("Unable to create newDocumentBuilder!");
        }

        Document doc = db.newDocument();
        
        Element root = doc.createElement("KVCache");
        doc.appendChild(root);
        
        // create an entry for every Set
        for (int i = 0; i < numSets; i++) {
            Element xmlset = doc.createElement("Set");
            xmlset.setAttribute("Id", Integer.toString(i));
            root.appendChild(xmlset);
            
            sets[i].toXML(xmlset, doc);
        }
        
        TransformerFactory transFactory = TransformerFactory.newInstance();
	    Transformer tran = null;
	    try {
			tran = transFactory.newTransformer();
		} catch (TransformerConfigurationException e) {
			System.out.print("Unable to create transformer!");
		}
        
	    StringWriter sw = new StringWriter();
	    StreamResult result = new StreamResult(sw);
	    doc.setXmlStandalone(true);
	    DOMSource source = new DOMSource(doc);
	    try {
			tran.transform(source, result);
		} catch (TransformerException e) {
			System.out.print("Transformer Exception catched!");
		}
	    return sw.toString();
    }
    
public class CacheSet {
        
        private int numElements;
        private LinkedList<queueNode> queue = new LinkedList<queueNode>();
        private Map<String, String> data = new HashMap<String, String>();
        
        public CacheSet (int elements) {
            numElements = elements;
        }
        
        public void putInCache(String key, String value) {
            queueNode temp;
            //check the queue to see if there is already an entry, set referenced to TRUE and update its value 
            for (int i = 0; i < queue.size(); i++) {
                temp = queue.get(i);
                if (temp.key.equals(key)) {
                    temp.referenced = true;
                    data.put(key, value);
                    return;
                }
            }
            // add the key if not in the queue, use the second chance algorithm to remove one if the set is full
            temp = new queueNode(key);
            //temp.referenced = true;     ???????????????????????????????????
            if (queue.size() >= numElements) {
            	delInCache();
            }
            queue.add(temp);
            data.put(key, value);
        }
        
        public String getInCache(String key){
            // find the entry in the queue and set its referenced bit to true
            for (int i = 0; i < queue.size(); i++) {
                if (queue.get(i).key == key) {
                    queue.get(i).referenced = true;
                    break;
                }
            }
            
            //get() in Map returns null if hash table does not contain the key
            return data.get(key);
        }
        
        // deletes the oldest, least recently used item from this set
        public void delInCache() {
            queueNode temp;
            while(true) {
                temp = queue.getFirst();
                if (temp == null) {
                    return;
                }
                queue.remove();		//remove the first element from the queue first
                if (temp.referenced == false) {
                    data.remove(temp.key);
                    return;
                } else {		// if reference bit is true, put it back at the end of the queue
                    temp.referenced = false;
                    queue.add(temp);
                }
            }
        }
        
        // deletes a specific item from this set
        public void delInCache(String key) {
            queueNode temp;
            for (int i = 0; i < queue.size(); i++) {
                temp = queue.get(i);
                if (temp.key.equals(key)) {
                    queue.remove(i);
                    data.remove(key);
                }
            }
        }
        
        //append change into "doc"
        public void toXML(Element xmlset, Document doc) {
            for (int i = 0; i < queue.size(); i++) {
                queueNode temp = queue.get(i);
                
                // create a CacheEntry
                Element xmlentry = doc.createElement("CacheEntry");
                xmlentry.setAttribute("isReferenced", Boolean.toString(temp.referenced));
                xmlset.appendChild(xmlentry);
                
                // add its key
                Element xmlkey = doc.createElement("Key");
                Text keytext = doc.createTextNode(temp.key);
                xmlentry.appendChild(xmlkey);
                xmlkey.appendChild(keytext);
                
                // add its value
                Element xmlvalue = doc.createElement("Value");
                Text valuetext = doc.createTextNode(data.get(temp.key));
                xmlentry.appendChild(xmlvalue);
                xmlvalue.appendChild(valuetext);
            }
        }
        
        public class queueNode {
            public boolean referenced = false;
            public String key;
            
            public queueNode(String key) {
                this.key = key;
            }
        }
    }
}
