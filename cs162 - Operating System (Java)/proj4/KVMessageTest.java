package edu.berkeley.cs162;

import static org.junit.Assert.*;

import org.junit.Test;

public class KVMessageTest {

	@Test
	public void test() {
		//fail("Not yet implemented");
		try {
			KVMessage kvm = new KVMessage("commit","111");
			System.out.println(kvm.toXML());
			kvm = new KVMessage("abort","some error","112");
			System.out.println(kvm.toXML());
			kvm = new KVMessage("abort","113");
			System.out.println(kvm.toXML());
			kvm = new KVMessage("ready","114");
			System.out.println(kvm.toXML());
			kvm = new KVMessage("ack","115");
			System.out.println(kvm.toXML());
			kvm = new KVMessage("register","114");
			System.out.println(kvm.toXML());
			kvm = new KVMessage("resp","message");
			System.out.println(kvm.toXML());
			kvm = new KVMessage("getreq","1");
			System.out.println(kvm.toXML());
			kvm = new KVMessage("resp");
			//kvm.setMsgType("resp");
			kvm.setValue("2");
			kvm.setMessage("aaa");
			System.out.println(kvm.toXML());
			//kvm = new KVMessage("putreq","1","2","116");
			//System.out.print(kvm.toXML());
			//kvm = new KVMessage("delreq","1","114");
			//System.out.print(kvm.toXML());
		} catch (KVException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

}
