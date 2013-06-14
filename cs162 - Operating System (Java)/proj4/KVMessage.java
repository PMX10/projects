/**
 * XML Parsing library for the key-value store
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

import java.io.BufferedReader;
import java.io.FilterInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintStream;
import java.io.Serializable;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.Socket;

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
 * This is the object that is used to generate messages the XML based messages 
 * for communication between clients and servers. 
 */
public class KVMessage implements Serializable {
	
	private static final long serialVersionUID = 6473128480951955693L;
	
	private String msgType = null;
	private String key = null;
	private String value = null;
	private String message = null;
    private String tpcOpId = null;    
	
	public final String getKey() {
		return key;
	}

	public final void setKey(String key) {
		this.key = key;
	}

	public final String getValue() {
		return value;
	}

	public final void setValue(String value) {
		this.value = value;
	}

	public final String getMessage() {
		return message;
	}

	public final void setMessage(String message) {
		this.message = message;
	}

	public String getMsgType() {
		return msgType;
	}
	
	public void setMsgType(String msgType) {
		this.msgType = msgType;
	}

	public String getTpcOpId() {
		return tpcOpId;
	}

	public void setTpcOpId(String tpcOpId) {
		this.tpcOpId = tpcOpId;
	}

	/* Solution from http://weblogs.java.net/blog/kohsuke/archive/2005/07/socket_xml_pitf.html */
	private class NoCloseInputStream extends FilterInputStream {
	    public NoCloseInputStream(InputStream in) {
	        super(in);
	    }
	    
	    public void close() {} // ignore close
	}
	
	private boolean isValidType(String t) throws KVException{
		try{
			return t.equals("getreq") || t.equals("delreq") || t.equals("putreq") || t.equals("resp") || t.equals("ready") || t.equals("abort") || t.equals("commit") || t.equals("ack") || t.equals("register") || t.equals("ignoreNext");	
		}catch(Exception wrongType){
			throw new KVException(new KVMessage("resp", "Unknown Error: Message format incorrect"));
		}
	}
	
	/***
	 * 
	 * @param msgType
	 * @throws KVException of type "resp" with message "Message format incorrect" if msgType is unknown
	 */
	public KVMessage(String msgType) throws KVException {
		
		if (!isValidType(msgType))
			throw new KVException(new KVMessage("resp", "Unknown Error: Message format incorrect"));
		
		this.msgType = msgType;
	}
	
	public KVMessage(String msgType, String message) throws KVException {
		
		if (!isValidType(msgType))
			throw new KVException(new KVMessage("resp", "Unknown Error: Message format incorrect"));
		
		this.msgType = msgType;
		if (msgType.equals("getreq") || msgType.equals("delreq"))
			this.key = message;
		else if (msgType.equals("commit") || msgType.equals("abort")|| msgType.equals("ack") || msgType.equals("ready"))
			this.tpcOpId = message;
		else if(msgType.equals("register")||msgType.equals("resp"))
				this.message = message;
	}
	
	//constructor added for convenience
	public KVMessage(String msgType, String key, String value) throws KVException {
		if (!isValidType(msgType))
			throw new KVException(new KVMessage("resp", "Unknown Error: Message format incorrect"));
		
		this.msgType = msgType;
		if (msgType.equals("delreq")){
			this.key = key;
			this.tpcOpId = value;
		}
		else if (msgType.equals("abort")){
			this.message = key;
			this.tpcOpId = value;
		}
		else{
			this.key = key;
			this.value = value;
		}
	}

	 /***
     * Parse KVMessage from incoming network connection
     * @param sock
     * @throws KVException if there is an error in parsing the message. The exception should be of type "resp and message should be :
     * a. "XML Error: Received unparseable message" - if the received message is not valid XML.
     * b. "Network Error: Could not receive data" - if there is a network error causing an incomplete parsing of the message.
     * c. "Message format incorrect" - if there message does not conform to the required specifications. Examples include incorrect message type. 
     */
	public KVMessage(InputStream input) throws KVException {
	     // TODO: implement me
		String line;
		BufferedReader br = new BufferedReader(new InputStreamReader(input));
		//read line;
		try {
			line = br.readLine();
		} catch (IOException e) {
			throw new KVException(new KVMessage("resp","XML Error: Received unparseable message"));
		}
	
		InputSource ins = new InputSource();
		ins.setCharacterStream(new StringReader(line));
		DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder db = null;
		
		//build a new document
		try {
			db = dbFactory.newDocumentBuilder();
		} catch (ParserConfigurationException e) {
			throw new KVException(new KVMessage("resp","XML Error: Received unparseable message"));
		}
		
		Document doc = null;
		//read from input source
		try {
			doc = db.parse(ins);
		} catch (SAXException e) {
			throw new KVException(new KVMessage("resp","XML Error: Received unparseable message"));
		} catch (IOException e) {
			throw new KVException(new KVMessage("resp","XML Error: Received unparseable message"));
		}
	
		//read type from element
		Element root = doc.getDocumentElement();
		
		//get msgType
		String type = root.getAttribute("type");
        if (!isValidType(type))
			throw new KVException(new KVMessage("resp", "Unknown Error: Message format incorrect"));
        this.msgType = type;
		
        //get key
		NodeList node = root.getElementsByTagName("Key");
		if(node.getLength() >0){
			this.key = node.item(0).getFirstChild().getNodeValue();
			if (this.key.length() > 256 && type.equals("putreq")){
				throw new KVException(new KVMessage("resp", "Oversized key"));
			}
		}
		
		//get value
		node = root.getElementsByTagName("Value");
		if(node.getLength() > 0){
			this.value = node.item(0).getFirstChild().getNodeValue();
			if (this.value.length() > 256*1024){      // 256KB
				throw new KVException(new KVMessage("resp", "Oversized value"));
			}
		}
		
		//get message
		node = root.getElementsByTagName("Message");
		if(node.getLength() >0){
			this.message = node.item(0).getFirstChild().getNodeValue();
		}
		//get tpcOpId
		node = root.getElementsByTagName("TPCOpId");
		if (node.getLength()>0){
			this.tpcOpId = node.item(0).getFirstChild().getNodeValue(); 
		}
	}
	
	/**
	 * 
	 * @param sock Socket to receive from
	 * @throws KVException if there is an error in parsing the message. The exception should be of type "resp and message should be :
	 * a. "XML Error: Received unparseable message" - if the received message is not valid XML.
	 * b. "Network Error: Could not receive data" - if there is a network error causing an incomplete parsing of the message.
	 * c. "Message format incorrect" - if there message does not conform to the required specifications. Examples include incorrect message type. 
	 */
	public KVMessage(Socket sock) throws KVException {
		
	}

	/**
	 * 
	 * @param sock Socket to receive from
	 * @param timeout Give up after timeout milliseconds
	 * @throws KVException if there is an error in parsing the message. The exception should be of type "resp and message should be :
	 * a. "XML Error: Received unparseable message" - if the received message is not valid XML.
	 * b. "Network Error: Could not receive data" - if there is a network error causing an incomplete parsing of the message.
	 * c. "Message format incorrect" - if there message does not conform to the required specifications. Examples include incorrect message type. 
	 */
	public KVMessage(Socket sock, int timeout) throws KVException {
	     // TODO: implement me
	}
	
	/**
	 * Copy constructor
	 * 
	 * @param kvm
	 */
	public KVMessage(KVMessage kvm) {
		this.msgType = kvm.msgType;
		this.key = kvm.key;
		this.value = kvm.value;
		this.message = kvm.message;
		this.tpcOpId = kvm.tpcOpId;
	}

	/**
	 * Generate the XML representation for this message.
	 * @return the XML String
	 * @throws KVException if not enough data is available to generate a valid KV XML message
	 */
	public String toXML() throws KVException {
        //return null;
	      // TODO: implement me
		DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
	    DocumentBuilder db = null;
	   
		KVMessage err = new KVMessage("resp", "Unknown Error: not enough information to generate a XML");
		
		try {
			db = dbFactory.newDocumentBuilder();
		} catch (ParserConfigurationException e1) {
			throw new KVException(new KVMessage("resp","Unknown Error: can not create newDocumentBuilder"));
		}
	    Document doc = db.newDocument();
	     
	    //getreq and delreq
	    if (this.msgType.equals("getreq") || this.msgType.equals("delreq")){
	    	if (this.key == null){
	    		throw new KVException(err);
	    	}
	    	Element root = doc.createElement("KVMessage");
	   		root.setAttribute("type", this.msgType);
	   		doc.appendChild(root);
	   		Element key = doc.createElement("Key");
	   		root.appendChild(key);
	   		Text keyValue = doc.createTextNode(this.key);
	   		key.appendChild(keyValue);
	   		if (this.tpcOpId != null){
	    		Element tpcOpId = doc.createElement("TPCOpId");
		    	root.appendChild(tpcOpId);
		    	Text tpcOpIdValue = doc.createTextNode(this.tpcOpId);
		    	tpcOpId.appendChild(tpcOpIdValue);
	   		}
	    }
	    

	    //	putreq
	    else if (this.msgType.equals("putreq")){
	    	if (this.key == null || this.value == null){
	    		throw new KVException(err);
	    	}
	    		
	    	Element root = doc.createElement("KVMessage");
	    	root.setAttribute("type", this.msgType);
	    	doc.appendChild(root);
	    	Element key = doc.createElement("Key");
	    	root.appendChild(key);
	    	Text keyValue = doc.createTextNode(this.key);
	    	key.appendChild(keyValue);
	    	Element value = doc.createElement("Value");
	    	root.appendChild(value);
	    	Text valueValue = doc.createTextNode(this.value);
	    	value.appendChild(valueValue);
	    	if (this.tpcOpId != null){
	    		Element tpcOpId = doc.createElement("TPCOpId");
		    	root.appendChild(tpcOpId);
		    	Text tpcOpIdValue = doc.createTextNode(this.tpcOpId);
		    	tpcOpId.appendChild(tpcOpIdValue);
	    	}
	    }
	  //resp with value and message
	    else if (this.msgType.equals("resp") && this.value!=null && this.message!= null){
	    	if (this.message == null){
	    		throw new KVException(err);
	    	}
	    	Element root = doc.createElement("KVMessage");
	    	root.setAttribute("type", this.msgType);
	    	doc.appendChild(root);
	    	
	    	Element value = doc.createElement("Value");
	    	root.appendChild(value);
	    	Text valueValue = doc.createTextNode(this.value);
	    	value.appendChild(valueValue);
	    	
	    	Element msg = doc.createElement("Message");
	    	root.appendChild(msg);
	    	Text msgValue = doc.createTextNode(this.message);
	    	msg.appendChild(msgValue);
	    }
	    //resp with key and value
	    else if (this.msgType.equals("resp") && this.key != null && this.value != null){
	    	if (this.key == null || this.value == null){
	    		throw new KVException(err);
	    	}
	    	Element root = doc.createElement("KVMessage");
	    	root.setAttribute("type", this.msgType);
	    	doc.appendChild(root);
	    	
	    	Element key = doc.createElement("Key");
	    	root.appendChild(key);
	    	Text keyValue = doc.createTextNode(this.key);
	    	key.appendChild(keyValue);
	    	
	    	Element value = doc.createElement("Value");
	    	root.appendChild(value);
	    	Text valueValue = doc.createTextNode(this.value);
	    	value.appendChild(valueValue);
	    }
	  
	    //resp with message or register
	    else if (this.msgType.equals("resp") ||  this.msgType.equals("register")){
	    	if (this.message == null){
	    		throw new KVException(err);
	    	}
	    	Element root = doc.createElement("KVMessage");
	    	root.setAttribute("type", this.msgType);
	    	doc.appendChild(root);
	    	
	    	Element msg = doc.createElement("Message");
	    	root.appendChild(msg);
	    	Text msgValue = doc.createTextNode(this.message);
	    	msg.appendChild(msgValue);
	    }
	    
	    //ready commit ack
	    else if (this.msgType.equals("ready") || this.msgType.equals("commit") || this.msgType.equals("ack")){
	    	Element root = doc.createElement("KVMessage");
	    	root.setAttribute("type", this.msgType);
	    	doc.appendChild(root);
	    	
	    	Element tpcOpId = doc.createElement("TPCOpId");
	    	root.appendChild(tpcOpId);
	    	Text tpcOpIdValue = doc.createTextNode(this.tpcOpId);
	    	tpcOpId.appendChild(tpcOpIdValue);
	    }
	    //abort
	    else if (this.msgType.equals("abort")){
	    	Element root = doc.createElement("KVMessage");
	    	root.setAttribute("type", this.msgType);
	    	doc.appendChild(root);
	    	
	    	if (this.message != null){
	    	Element msg = doc.createElement("Message");
	    	root.appendChild(msg);
	    	Text msgValue = doc.createTextNode(this.message);
	    	msg.appendChild(msgValue);
	    	}
	    	
	    	Element tpcOpId = doc.createElement("TPCOpId");
	    	root.appendChild(tpcOpId);
	    	Text tpcOpIdValue = doc.createTextNode(this.tpcOpId);
	    	tpcOpId.appendChild(tpcOpIdValue);
	    }
	    
	    //ignoreNext
	    else if (this.msgType.equals("ignoreNext")){
	    	Element root = doc.createElement("KVMessage");
	    	root.setAttribute("type", this.msgType);
	    	doc.appendChild(root);
	    }
	 

	    TransformerFactory transFactory = TransformerFactory.newInstance();
	    Transformer tran = null;
		try {
			tran = transFactory.newTransformer();
		} catch (TransformerConfigurationException e) {
    		throw new KVException(new KVMessage("resp", "Unknown Error: can not create transformer"));
		}
	 

	    StringWriter sw = new StringWriter();
	    StreamResult result = new StreamResult(sw);
	    doc.setXmlStandalone(true);
	    DOMSource source = new DOMSource(doc);
	    try {
			tran.transform(source, result);
		} catch (TransformerException e) {
    		throw new KVException(new KVMessage("resp", "Unknown Error: TransformerException occured"));
		}
	    
	    return sw.toString();
	}
	
	public void sendMessage(Socket sock) throws KVException {
	      // TODO: implement me
		try {
			//String xml = toXML();
			//System.out.println(xml);
			OutputStream out = sock.getOutputStream();
			PrintStream ps = new PrintStream(out, true);
			ps.println(toXML());
			out.flush();
			sock.shutdownOutput();
		} catch (IOException e) {
    		throw new KVException(new KVMessage("resp", "Network Error: Could not send data"));
		}
	}
	
	public void sendMessage(Socket sock, int timeout) throws KVException {
		// TODO: optional implement me
	}
}
