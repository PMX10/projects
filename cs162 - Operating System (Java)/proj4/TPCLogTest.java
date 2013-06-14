package edu.berkeley.cs162;

import static org.junit.Assert.*;

import org.junit.Test;

public class TPCLogTest {

	@Test
	public void test(){
		//fail("Not yet implemented");
		KVServer sv = new KVServer(10,100);
		TPCLog log = new TPCLog("file_name",sv);
		
		KVMessage put1;
		try {
			put1 = new KVMessage("putreq","k1","v1");
		
		put1.setTpcOpId("1");
		log.appendAndFlush(put1);
		log.appendAndFlush(new KVMessage("commit","1"));
		
		KVMessage put2 = new KVMessage("putreq","k2","v2");
		put2.setTpcOpId("2");
		log.appendAndFlush(put2);
		log.appendAndFlush(new KVMessage("commit","2"));
		
		KVMessage del1 = new KVMessage("delreq","k2","v2");
		del1.setTpcOpId("3");
		log.appendAndFlush(del1);
		log.appendAndFlush(new KVMessage("abort","3"));
		
		log.loadFromDisk();
		log.rebuildKeyServer();
		System.out.println(sv.get("k1"));
		
		KVMessage del2 = new KVMessage("delreq","k2","v2");
		del2.setTpcOpId("4");
		log.appendAndFlush(del2);
		log.appendAndFlush(new KVMessage("abort","4"));
		System.out.println(sv.get("k2"));
		
		KVMessage put3 = new KVMessage("putreq","k3","v3");
		put3.setTpcOpId("5");
		//System.out.println(sv.get("k3"));
		
		KVMessage com1 = new KVMessage("commit","6");  //test for extra commit
		log.appendAndFlush(com1);
		System.out.println(sv.get("k3"));
		} catch (KVException e) {
			// TODO Auto-generated catch block
			System.out.println(e.getMsg());
		}
	}

}
