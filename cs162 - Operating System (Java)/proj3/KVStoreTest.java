package edu.berkeley.cs162;

import static org.junit.Assert.*;

import org.junit.Test;

public class KVStoreTest {

	@Test
	public void test() {
		//fail("Not yet implemented");
		KVStore kvs = new KVStore();
		KVStore temp = new KVStore();
		try {
			kvs.put("1", "a");
			kvs.put("2", "b");
			kvs.put("3", "c");
			System.out.println(kvs.get("1"));
			kvs.del("1");
			//kvs.del("1");  //no exception
			kvs.dumpToFile("data.xml");
			kvs.restoreFromFile("data.xml");
			System.out.println(kvs.get("2"));
			System.out.println(kvs.get("3"));
			System.out.println(kvs.get("1"));   //should throw exception
		} catch (KVException e) {
			// TODO Auto-generated catch block
			System.out.print(e.getMsg().getMessage());
		}
	}

}
