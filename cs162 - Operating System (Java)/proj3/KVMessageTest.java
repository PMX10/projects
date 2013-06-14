package edu.berkeley.cs162;

import static org.junit.Assert.*;

import org.junit.Test;

public class KVMessageTest {
	@Test
	public void test() {
		//fail("Not yet implemented");
		try {
			//KVMessage kvm = new KVMessage("getreq");
			KVMessage kvm2 = new KVMessage("resp","some resp");
			KVMessage kvm3 = new KVMessage("putreq","KEY","MESSAGE");
			//System.out.println(kvm.toXML());
			System.out.println(kvm2.toXML());
			System.out.println(kvm3.toXML());
		} catch (KVException e) {
			// TODO Auto-generated catch block
			System.out.print(e.getMsg().getMessage());
		}
		
	}

}
