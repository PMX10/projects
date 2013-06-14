package nachos.threads;

import nachos.machine.*;

//import java.util.TreeSet;
//import java.util.HashSet;
//import java.util.Iterator;
import java.util.*;

/**
 * A scheduler that chooses threads based on their priorities.
 *
 * <p>
 * A priority scheduler associates a priority with each thread. The next thread
 * to be dequeued is always a thread with priority no less than any other
 * waiting thread's priority. Like a round-robin scheduler, the thread that is
 * dequeued is, among all the threads of the same (highest) priority, the
 * thread that has been waiting longest.
 *
 * <p>
 * Essentially, a priority scheduler gives access in a round-robin fassion to
 * all the highest-priority threads, and ignores all other threads. This has
 * the potential to
 * starve a thread if there's always a thread waiting with higher priority.
 *
 * <p>
 * A priority scheduler must partially solve the priority inversion problem; in
 * particular, priority must be donated through locks, and through joins.
 */
public class PriorityScheduler extends Scheduler {
    /**
     * Allocate a new priority scheduler.
     */
    public PriorityScheduler() {
    }
    
    /**
     * Allocate a new priority thread queue.
     *
     * @param	transferPriority	<tt>true</tt> if this queue should
     *					transfer priority from waiting threads
     *					to the owning thread.
     * @return	a new priority thread queue.
     */
    public ThreadQueue newThreadQueue(boolean transferPriority) {
    	//System.out.print("1 ");
	return new PriorityQueue(transferPriority);
    }

    public int getPriority(KThread thread) {
    System.out.print("2 ");
	Lib.assertTrue(Machine.interrupt().disabled());
		       
	return getThreadState(thread).getPriority();
    }

    public int getEffectivePriority(KThread thread) {
	Lib.assertTrue(Machine.interrupt().disabled());
	System.out.print("3 ");
		       
	return getThreadState(thread).getEffectivePriority();
    }

    public void setPriority(KThread thread, int priority) {
	Lib.assertTrue(Machine.interrupt().disabled());
		       
	Lib.assertTrue(priority >= priorityMinimum &&
		   priority <= priorityMaximum);
	//System.out.print("4 ");
	getThreadState(thread).setPriority(priority);
    }

    public boolean increasePriority() {
	boolean intStatus = Machine.interrupt().disable();
		       
	KThread thread = KThread.currentThread();

	int priority = getPriority(thread);
	if (priority == priorityMaximum)
	    return false;

	setPriority(thread, priority+1);

	Machine.interrupt().restore(intStatus);
	return true;
    }

    public boolean decreasePriority() {
	boolean intStatus = Machine.interrupt().disable();
		       
	KThread thread = KThread.currentThread();

	int priority = getPriority(thread);
	if (priority == priorityMinimum)
	    return false;

	setPriority(thread, priority-1);

	Machine.interrupt().restore(intStatus);
	return true;
    }

    /**
     * The default priority for a new thread. Do not change this value.
     */
    public static final int priorityDefault = 1;
    /**
     * The minimum priority that a thread can have. Do not change this value.
     */
    public static final int priorityMinimum = 0;
    /**
     * The maximum priority that a thread can have. Do not change this value.
     */
    public static final int priorityMaximum = 7;    

    /**
     * Return the scheduling state of the specified thread.
     *
     * @param	thread	the thread whose scheduling state to return.
     * @return	the scheduling state of the specified thread.
     */
    protected ThreadState getThreadState(KThread thread) {
    	//System.out.print("!!!!!!!!!");
	if (thread.schedulingState == null)
	    thread.schedulingState = new ThreadState(thread);

	return (ThreadState) thread.schedulingState;
    }

    /**
     * A <tt>ThreadQueue</tt> that sorts threads by priority.
     */
    protected class PriorityQueue extends ThreadQueue {
	PriorityQueue(boolean transferPriority) {
		//System.out.print("6 ");
	    this.transferPriority = transferPriority;
	}

	public void waitForAccess(KThread thread) {
		System.out.print("7 ");
	    Lib.assertTrue(Machine.interrupt().disabled());
	    getThreadState(thread).waitForAccess(this);
	}

	public void acquire(KThread thread) {
		System.out.print("8 ");
	    Lib.assertTrue(Machine.interrupt().disabled());
	    getThreadState(thread).acquire(this);
	}

	public KThread nextThread() {
		System.out.print("9 ");
	    Lib.assertTrue(Machine.interrupt().disabled());
	    // implement me
	    if(this.current!=null)
	    	getThreadState(this.current).Resources.remove(this);
	    ThreadState wanted = this.pickNextThread();
	    if(wanted==null)
	    {
	    	//System.out.print("next = null");
	    	return null;
	    }
	    this.current = wanted.thread;
	    getThreadState(this.current).priority_need_change = true;
	    this.queue.remove(wanted);
	    this.acquire(this.current);
	    return this.current;
	    //return null;
	}

	/**
	 * Return the next thread that <tt>nextThread()</tt> would return,
	 * without modifying the state of this queue.
	 *
	 * @return	the next thread that <tt>nextThread()</tt> would
	 *		return.
	 */
	protected ThreadState pickNextThread() {
		System.out.print("10 ");
	    // implement me
		if(queue.isEmpty())
			return null;
		//if(this.transferPriority)
		//{
			ThreadState wanted = queue.peek();
			//for(ThreadState ts:this.queue)
			//	ts.priority_need_change = true;
		    return wanted;
		//}
		/*else
		{
			int max_priority = priorityMinimum;
			int temp_priority = priorityMinimum;
			ThreadState wanted = this.queue.peek();
			for(ThreadState threadstate:queue)
			{
				temp_priority = threadstate.priority;
				if(max_priority == temp_priority)
				{
					if(wanted.time < threadstate.time)
						wanted = threadstate;
				}
				else if(max_priority < temp_priority)
				{
					max_priority = temp_priority;
					wanted = threadstate;
				}
			}
			return wanted;
		}*/
	}
	
	public void print() {
	    Lib.assertTrue(Machine.interrupt().disabled());
	    // implement me (if you want)
	}

	/**
	 * <tt>true</tt> if this queue should transfer priority from waiting
	 * threads to the owning thread.
	 */
	public boolean transferPriority;
	/////////////////
	protected java.util.PriorityQueue<ThreadState> queue = new java.util.PriorityQueue<ThreadState>();
	protected KThread current;
    }

    /**
     * The scheduling state of a thread. This should include the thread's
     * priority, its effective priority, any objects it owns, and the queue
     * it's waiting for, if any.
     *
     * @see	nachos.threads.KThread#schedulingState
     */
    protected class ThreadState implements Comparable<ThreadState> {
	/**
	 * Allocate a new <tt>ThreadState</tt> object and associate it with the
	 * specified thread.
	 *
	 * @param	thread	the thread this state belongs to.
	 */
	public ThreadState(KThread thread) {
		//System.out.print("11 ");
	    this.thread = thread;
	    setPriority(priorityDefault);
	}

	/**
	 * Return the priority of the associated thread.
	 *
	 * @return	the priority of the associated thread.
	 */
	public int getPriority() {
		//System.out.print("12 ");
	    return priority;
	}

	/**
	 * Return the effective priority of the associated thread.
	 *
	 * @return	the effective priority of the associated thread.
	 */
	public int getEffectivePriority() {
		System.out.print("13 ");
	    // implement me
//		if(this.priority_need_change == false)
//		{
//			if(this.priority>this.effective_priority)
//				return this.priority;
//			return this.effective_priority;
//		}
		this.effective_priority = this.priority;
		for(PriorityQueue pq: Resources)
		{
			if(pq.transferPriority)
			{
				for(ThreadState threadstate:pq.queue)
				{
					int tep =  threadstate.getEffectivePriority();
					//System.out.print("--->"+tep);
					if(this.effective_priority < tep)
					{
						this.effective_priority = tep;
					}
				}
			}
		}
		this.priority_need_change = false;
	    return this.effective_priority;
	}

	/**
	 * Set the priority of the associated thread to the specified value.
	 *
	 * @param	priority	the new priority.
	 */
	public void setPriority(int priority) {
		//System.out.print("14 ");
	    if (this.priority == priority)
	    return;
	 // implement me
	    if (priority <= PriorityScheduler.priorityMaximum && priority >= PriorityScheduler.priorityMinimum)
	    {
	    	priority_need_change = true;
	    	this.priority = priority;
	    }
	    /*this.priority = priority;
	    this.priority_need_change = true;
	    if(this.priority > PriorityScheduler.priorityMaximum)
	    	this.priority = PriorityScheduler.priorityMaximum;
	    if(this.priority < PriorityScheduler.priorityMinimum)
    		this.priority = PriorityScheduler.priorityMinimum;*/
	}

	/**
	 * Called when <tt>waitForAccess(thread)</tt> (where <tt>thread</tt> is
	 * the associated thread) is invoked on the specified priority queue.
	 * The associated thread is therefore waiting for access to the
	 * resource guarded by <tt>waitQueue</tt>. This method is only called
	 * if the associated thread cannot immediately obtain access.
	 *
	 * @param	waitQueue	the queue that the associated thread is
	 *				now waiting on.
	 *
	 * @see	nachos.threads.ThreadQueue#waitForAccess
	 */
	public void waitForAccess(PriorityQueue waitQueue) {
		System.out.print("15 ");
	    // implement me
		for(ThreadState threadstate :waitQueue.queue)
			threadstate.priority_need_change = true;
		//System.out.print("add==>"+(ThreadState) this.thread.schedulingState);
		waitQueue.queue.add(this);
		this.time = Machine.timer().getTime();
	}

	/**
	 * Called when the associated thread has acquired access to whatever is
	 * guarded by <tt>waitQueue</tt>. This can occur either as a result of
	 * <tt>acquire(thread)</tt> being invoked on <tt>waitQueue</tt> (where
	 * <tt>thread</tt> is the associated thread), or as a result of
	 * <tt>nextThread()</tt> being invoked on <tt>waitQueue</tt>.
	 *
	 * @see	nachos.threads.ThreadQueue#acquire
	 * @see	nachos.threads.ThreadQueue#nextThread
	 */
	public void acquire(PriorityQueue waitQueue) {
		System.out.print("16 ");
	    // implement me
		if ((this.thread != null) && (waitQueue != null)) {
		waitQueue.current = this.thread;
		this.priority_need_change = true;
		this.Resources.add(waitQueue);
		}
	}	
	public int compareTo(ThreadState ts)
	{
		//System.out.print("17 ");
		/*if(ts.priority_need_change == true)
		{
			ts.effective_priority = ts.getEffectivePriority();
			ts.priority_need_change = false;
		}*/
		/*if(this.priority_need_change == true)
		{
			this.effective_priority = this.getEffectivePriority();
			this.priority_need_change = false;
		}*/
		//return 0;
		if(ts == null)
			return 0;
		int ts_p = ts.getEffectivePriority();
		int my_p = this.getEffectivePriority();
		if(ts_p > my_p)
		//if(ts.effective_priority > this.effective_priority)
			return 1;
		else if(ts_p < my_p)
		//else if(ts.effective_priority < this.effective_priority)
			return -1;
		else if(ts_p == my_p)
		//else if(ts.effective_priority == this.effective_priority)
			if(ts.time > this.time)
				return -1;
			else
				return 1;
		return 0;
	}
	/** The thread with which this object is associated. */	   
	protected KThread thread;
	/** The priority of the associated thread. */
	protected int priority;
	//////////////////////////
	protected int effective_priority = 0;
	protected LinkedList<PriorityQueue> Resources = new LinkedList<PriorityQueue>();
	protected boolean priority_need_change = true;
	protected long time = 0;
    }
}
