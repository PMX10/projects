/**
 * Sample instantiation of the Key-Value client  
 * 
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

import java.io.IOException;

public class Client {
	public static void main(String[] args) throws IOException {
		KVClient kc = new KVClient("localhost",8080);
		//KVClient kc = new KVClient("136.152.37.140",8080);
		
		System.out.println("Start");
		try{			
			//System.out.println("delete the first three");
			//kc.del("three");
			
			//System.out.println("delete the second three");
			//kc.del("three");
			
			String three = "three";
			String seven = "seven";
			System.out.println("putting" + " (3, 7)");
			kc.put(three, seven);
			kc.put("four", "eight");
			kc.put("five", "nine");
			
			//get key doesn't exist
			System.out.println("getting key=three");			
			String value = kc.get("three");		
			System.out.println("returned: " + value);
			
			System.out.println("getting key=four");			
			value = kc.get("four");		
			System.out.println("returned: " + value);
			
			System.out.println("getting key=five");			
			value = kc.get("five");		
			System.out.println("returned: " + value);
			//put
			//System.out.println("putting" + " (3, 7)");
			//kc.put(three, seven);
			
			//delete
			/*
			System.out.println("deleting: three");
			kc.del(three);
			System.out.println("successfully delete");
			
			value = kc.get(three);
			*/
			//System.out.println("returned: " + value);
			//System.out.println("deleting: three again!!");
			//kc.del(three);
			//value = kc.get(three);		
			//String value = kc.get("1");
			//System.out.println("returned: " + value);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
