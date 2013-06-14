package edu.berkeley.cs162;

import static org.junit.Assert.*;

import org.junit.Test;


public class ThreadPoolTest {
	
	class Task implements Runnable{
			
			public int indicator;
			public int id;
			
			
			public Task(int initially,int id){
				this.indicator = initially;
				this.id = id;
			}
			public int getind(){
				return indicator;
			}
			public void run(){
				this.indicator = 1;
				System.out.println("R: " + id + ".");
			}
		}

	@Test
	public void test() {
		//fail("Not yet implemented");
		Task R1 = new Task(100,1);
		Task R2 = new Task(100,2);
		Task R3 = new Task(100,3);
		Task R4 = new Task(100,4);
		Task R5 = new Task(100,5);
		ThreadPool tp = new ThreadPool(5);
		System.out.println("R1 initial value : " + R1.getind());
		System.out.println("R2 initial value : " + R2.getind());
		System.out.println("R3 initial value : " + R3.getind());
		System.out.println("R4 initial value : " + R4.getind());
		System.out.println("R5 initial value : " + R5.getind());
		try {
			tp.addToQueue(R1);
			tp.addToQueue(R2);
			tp.addToQueue(R3);
			tp.addToQueue(R4);
			tp.addToQueue(R5);
			Thread.sleep(4000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("After running the task, R1 value is : " + R1.getind());
		System.out.println("After running the task, R2 value is : " + R2.getind());
		System.out.println("After running the task, R3 value is : " + R3.getind());
		System.out.println("After running the task, R4 value is : " + R4.getind());
		System.out.println("After running the task, R5 value is : " + R5.getind());
	}

}
