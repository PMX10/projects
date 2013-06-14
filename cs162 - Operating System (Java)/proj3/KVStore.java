/**
 * Persistent Key-Value storage layer. Current implementation is transient, 
 * but assume to be backed on disk when you do your project.
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
import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Dictionary;
import java.util.Enumeration;
import java.util.Hashtable;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.Text;


/**
 * This is a dummy KeyValue Store. Ideally this would go to disk, 
 * or some other backing store. For this project, we simulate the disk like 
 * system using a manual delay.
 *
 */
public class KVStore implements KeyValueInterface {
	private Dictionary<String, String> store = null;  ///////////
	
	public KVStore() {
		resetStore();
	}

	private void resetStore() {
		store = new Hashtable<String, String>();
	}
	
	public void put(String key, String value) throws KVException {
		AutoGrader.agStorePutStarted(key, value);
		
		try {
			putDelay();
			store.put(key, value);
		} finally {
			AutoGrader.agStorePutFinished(key, value);
		}
	}
	
	public String get(String key) throws KVException {
		AutoGrader.agStoreGetStarted(key);
		
		try {
			getDelay();
			String retVal = this.store.get(key);
			if (retVal == null) {
			    KVMessage msg = new KVMessage("resp", "key \"" + key + "\" does not exist in store");
			    throw new KVException(msg);
			}
			return retVal;
		} finally {
			AutoGrader.agStoreGetFinished(key);
		}
	}
	
	public void del(String key) throws KVException {
		AutoGrader.agStoreDelStarted(key);

		try {
			delDelay();
			if(key != null)
				this.store.remove(key);
		} finally {
			AutoGrader.agStoreDelFinished(key);
		}
	}
	
	private void getDelay() {
		AutoGrader.agStoreDelay();
	}
	
	private void putDelay() {
		AutoGrader.agStoreDelay();
	}
	
	private void delDelay() {
		AutoGrader.agStoreDelay();
	}
	
    public String toXML() throws KVException{   /////////////
        // TODO: implement me
        //return null;
    	try{
	    	DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
	    	DocumentBuilder db = dbFactory.newDocumentBuilder();
	    	Document doc = db.newDocument();
	    	
	    	Element root = doc.createElement("KVStore");
	    	doc.appendChild(root);
	    	
	    	Enumeration<String> keys = store.keys();
	    	//String current_key = keys.nextElement();
	    	//String current_value = store.get(current_key);
	    	while(keys.hasMoreElements())
	    	{
	    		String current_key = keys.nextElement();
		    	String current_value = store.get(current_key);
		    	
	    		Element pair = doc.createElement("KVPair");
	    		Element key = doc.createElement("key");
	    		Element value = doc.createElement("value");
	    		
	    		Text keyText = doc.createTextNode(current_key);
		    	Text valueText = doc.createTextNode(current_value);
		    	
		    	key.appendChild(keyText);
		    	value.appendChild(valueText);
		    	pair.appendChild(key);
		    	pair.appendChild(value);
		    	root.appendChild(pair);
	    		//current_key = keys.nextElement();
	    		//current_value = store.get(current_key);
	    	}
	    	TransformerFactory transFactory = TransformerFactory.newInstance();
			Transformer tran = transFactory.newTransformer();
			 
			StringWriter sw = new StringWriter();
			StreamResult result = new StreamResult(sw);
			DOMSource source = new DOMSource(doc);
			tran.transform(source, result);
			String str = sw.toString();
			System.out.println("this is xml from TO XML method :  " + str);
			return str;
    	} catch(Exception wrongType){
			KVMessage error = new KVMessage("resp","Unable to translate toXML succcessfully");
			throw new KVException(error);
		}
    	//return null;
    }        

    public void dumpToFile(String fileName) throws KVException {  ////////////
        // TODO: implement me
    	try {
			String xml = toXML();
			FileWriter outFile = new FileWriter(fileName);
	    	PrintWriter out = new PrintWriter(outFile);
	    	
	    	out.println(xml);
	    	out.close();
		} catch(Exception wrongType ){
			KVMessage error = new KVMessage("resp","IO Error");
			throw new KVException(error);
		}
    }

    /**
     * Replaces the contents of the store with the contents of a file
     * written by dumpToFile; the previous contents of the store are lost.
     * @param fileName the file to be read.
     */
    public void restoreFromFile(String fileName) throws KVException {
        // TODO: implement me
    	resetStore();
    	try{
	    	File input_file = new File(fileName);
	    	try {
		     	DocumentBuilderFactory dbF = DocumentBuilderFactory.newInstance();
		     	DocumentBuilder db = dbF.newDocumentBuilder();
		     	Document doc = null;
	     	
	     		doc = db.parse(input_file);
		    	doc.getDocumentElement().normalize();
		    	NodeList KVpairs = doc.getElementsByTagName("KVPair");
		    	
		    	for (int i = 0; i < KVpairs.getLength(); i++)
		    	{
				    Node node = KVpairs.item(i);
				    if (node.getNodeType() == Node.ELEMENT_NODE)
				    {
				    	Element KVpair = (Element) node;  
				    
					    NodeList keyList = KVpair.getElementsByTagName("key");
					    Element keyElmnt = (Element) keyList.item(0);
					    NodeList keyElmnt_list = keyElmnt.getChildNodes();
					    String key = keyElmnt_list.item(0).getNodeValue();
					
					    NodeList valList = KVpair.getElementsByTagName("value");
					    Element valElmnt = (Element) valList.item(0);
					    NodeList valElmnt_list = valElmnt.getChildNodes();
					    String val = valElmnt_list.item(0).getNodeValue();
					
					    store.put(key, val);
					    System.out.println("restore: (" + key + ", " + store.get(key)+")");
				    }
		    	}
	     	} catch(Exception wrongType ){
				KVMessage error = new KVMessage("resp","XML Error: Received unparseable message");
				throw new KVException(error);

			}
    	} catch(Exception wrongType ){
			KVMessage error = new KVMessage("resp","IO Error");
			throw new KVException(error);

		}
		    
    }
    /*public int size_t()
    {
    	return store.size();
    }*/
}
