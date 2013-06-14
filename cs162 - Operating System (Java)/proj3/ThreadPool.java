/**
 * A simple thread pool implementation
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

import java.util.*;
import java.util.concurrent.Semaphore;

public class ThreadPool {
	/**
	 * Set of threads in the threadpool
	 */
	protected Thread threads[] = null;
	
	public LinkedList<Runnable> taskQueue;
	public int poolsize;
	//public Semaphore accessQueueLock;
	//public Semaphore addToQueueLock;

	/**
	 * Initialize the number of threads required in the threadpool. 
	 * 
	 * @param size  How many threads in the thread pool.
	 */
	public ThreadPool(int size)
	{      
		if (size<=0){
			System.out.print("Thread pool size less than 0!");
			System.exit(0);
		}
		taskQueue = new LinkedList<Runnable>();
		//accessQueueLock = new Semaphore(0);
		//addToQueueLock = new Semaphore(1);
		poolsize = size;
		
		//initialize the threads
		threads = new Thread[size];
		for(int i=0 ; i<size ; i++){
			threads[i] = new WorkerThread(this);
			threads[i].start();
		}
	}

	/**
	 * Add a job to the queue of tasks that has to be executed. As soon as a thread is available, 
	 * it will retrieve tasks from this queue and start processing.
	 * @param r job that has to be executed asynchronously
	 * @throws InterruptedException 
	 */
	public synchronized void addToQueue(Runnable r) throws InterruptedException
	{
		//addToQueueLock.acquire();
		taskQueue.addLast(r);
		//accessQueueLock.release(); 	//the queue is now able to be accessed to get threads
		
		//addToQueueLock.release();
	}
	
	/** 
	 * Block until a job is available in the queue and retrieve the job
	 * @return A runnable task that has to be executed
	 * @throws InterruptedException 
	 */
	public synchronized Runnable getJob() throws InterruptedException {
		//accessQueueLock.acquire(); 		//get access request
		//if (taskQueue!=null)
		if(taskQueue.size()>0)
			return taskQueue.pop(); 	    //get job from taskQueue
		return null;
	}
}

/**
 * The worker threads that make up the thread pool.
 */
class WorkerThread extends Thread {
	/**
	 * The constructor.
	 * 
	 * @param o the thread pool 
	 */
	public ThreadPool threadpool;
	
	WorkerThread(ThreadPool o)
	{
	     this.threadpool = o;
	}

	/**
	 * Scan for and execute tasks.
	 */
	public void run()
	{
		try{
			Runnable temptask;
			while(true)
			{
				//System.out.print("here");
				temptask = threadpool.getJob();
				if(temptask!=null)
				{
					//System.out.print("aaa");
					temptask.run();
				}
			}
		}catch(Exception e){
			System.out.println("!!!!  getting an exception" + e);
		}	
	}
}
