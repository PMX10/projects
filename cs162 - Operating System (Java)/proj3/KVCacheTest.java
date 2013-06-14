package edu.berkeley.cs162;

import static org.junit.Assert.*;

import org.junit.Test;

public class KVCacheTest {

	@Test
	public void test() throws Exception {
		//fail("Not yet implemented");
		KVCache kvc = null;
		kvc = new KVCache(5,2);
		try{
		kvc.put("1", "a");
		assertEquals(kvc.get("1"), "a");
		
		kvc.put("2", "v2");
		assertEquals(kvc.get("2"), "v2");
		
		kvc.put("3", "v3");
		assertEquals(kvc.get("3"), "v3");
		
		kvc.put("4", "v4");
		assertEquals(kvc.get("4"), "v4");
		
		kvc.put("5", "v5");
		assertEquals(kvc.get("5"), "v5");
		
		kvc.put("6", "v6");
		assertEquals(kvc.get("6"), "v6");
		
		kvc.put("7", "v7");
		assertEquals(kvc.get("7"), "v7");
		
		kvc.put("8", "v8");
		assertEquals(kvc.get("8"), "v8");
		
		kvc.put("9", "v9");
		assertEquals(kvc.get("9"), "v9");
		
		kvc.put("10", "v10");
		assertEquals(kvc.get("10"), "v10");
		
		System.out.print(kvc.toXML());
		
		}
		catch(KVException e)
		{
			System.out.print(e.getMsg().getMessage());
		}
		
	}
}
