package nachos.threads;

import nachos.machine.*;
import nachos.threads.PriorityScheduler.ThreadState;

import java.util.LinkedList;
import java.util.TreeSet;
import java.util.HashSet;
import java.util.Iterator;
import java.lang.Math;

/**
 * A scheduler that chooses threads using a lottery.
 *
 * <p>
 * A lottery scheduler associates a number of tickets with each thread. When a
 * thread needs to be dequeued, a random lottery is held, among all the tickets
 * of all the threads waiting to be dequeued. The thread that holds the winning
 * ticket is chosen.
 *
 * <p>
 * Note that a lottery scheduler must be able to handle a lot of tickets
 * (sometimes billions), so it is not acceptable to maintain state for every
 * ticket.
 *
 * <p>
 * A lottery scheduler must partially solve the priority inversion problem; in
 * particular, tickets must be transferred through locks, and through joins.
 * Unlike a priority scheduler, these tickets add (as opposed to just taking
 * the maximum).
 */
public class LotteryScheduler extends PriorityScheduler {
    /**
     * Allocate a new lottery scheduler.
     */
    public LotteryScheduler() {
    }
    
    /**
     * Allocate a new lottery thread queue.
     *
     * @param	transferPriority	<tt>true</tt> if this queue should
     *					transfer tickets from waiting threads
     *					to the owning thread.
     * @return	a new lottery thread queue.
     */
    public ThreadQueue newThreadQueue(boolean transferPriority) {
	// implement me
	return new LotteryQueue(transferPriority);
    }
    
    public static int priorityMinimum = 1;
    public static int priorityMaximum = Integer.MAX_VALUE;
    
    /**
     * Return the scheduling state of the specified thread.
     *
     * @param	thread	the thread whose scheduling state to return.
     * @return	the scheduling state of the specified thread.
     */
    protected LotteryThreadState getThreadState(KThread thread) {
        if (thread == null) {
            return null;
        }
        if (thread.schedulingState == null)
            thread.schedulingState = new LotteryThreadState(thread);
        
        return (LotteryThreadState) thread.schedulingState;
    }
    
    protected class LotteryQueue extends PriorityQueue {
        
        protected java.util.LinkedList<KThread> waitQueue = new java.util.LinkedList<KThread>();
        
        LotteryQueue(boolean transferPriority) {
            super(transferPriority);
        }
        
        public void waitForAccess(KThread thread) {
            Lib.assertTrue(Machine.interrupt().disabled());
            if (thread != null)
                getThreadState(thread).waitForAccess(this);
        }
        
        public void acquire(KThread thread) {
            Lib.assertTrue(Machine.interrupt().disabled());
            getThreadState(thread).acquire(this);
        }
    	public KThread nextThread() {
    	    Lib.assertTrue(Machine.interrupt().disabled());
    	    // implement me
    	    if(this.current!=null)
    	    	getThreadState(this.current).resources.remove(this);
    	    LotteryThreadState wanted = this.pickNextThread();
    	    if(wanted==null)
    	    {
    	    	//System.out.print("next = null");
    	    	return null;
    	    }
    	    this.current = wanted.thread;
    	    getThreadState(this.current).priority_need_change = true;
    	    this.waitQueue.remove(this.current);
    	    this.acquire(this.current);
    	    return this.current;
    	}
        
        protected LotteryThreadState pickNextThread() {
            
            int lottery_total = 0;
            
            KThread next = null;
            
            // calculate the number of total number of lotteries
            for (KThread th: waitQueue) {
                if (transferPriority) {
                    lottery_total += getThreadState(th).getEffectivePriority();
                } else {
                    lottery_total += getThreadState(th).getPriority();
                }
            }
            // pick a winner lottery
            int winner = 1 + (int)(Math.random() * lottery_total);
            // pick the winner thread
            for(KThread th:this.waitQueue)
            {
            	if(winner<=0)
            		break;
            	next = th;
            	if (transferPriority)
            		winner -= getThreadState(th).getEffectivePriority();
                else
                    winner -= getThreadState(th).getPriority();
            }

            if (next == null) {
                return null;
            }

            return getThreadState(next);
        }
    }
    
    protected class LotteryThreadState extends ThreadState {
        
        protected LinkedList<LotteryQueue> resources = new LinkedList<LotteryQueue>();
        
        public LotteryThreadState(KThread thread) {
            super(thread);
        }
        
        public int getEffectivePriority() {
            if (this.priority_need_change) {
                this.effective_priority = this.priority;
                
                int next_ths_Priority;
                
                for(LotteryQueue lq : this.resources)
                {
                	if(lq == null)
                		break;
                	for(KThread th : lq.waitQueue)
                	{
                		if(th == null)
                			break;
                		next_ths_Priority = getThreadState(th).getEffectivePriority();
                		if (next_ths_Priority == LotteryScheduler.priorityMaximum) {
                            this.effective_priority = LotteryScheduler.priorityMaximum;
                            break;
                        } else if ((this.effective_priority + next_ths_Priority) < this.effective_priority) {
                            this.effective_priority = LotteryScheduler.priorityMaximum;
                        } else {
                            this.effective_priority = this.effective_priority + next_ths_Priority;
                        }
                		next_ths_Priority = 0;
                	}
                }
            }
            this.priority_need_change = false;
            return this.effective_priority;
        }
        
        
        public void waitForAccess(LotteryQueue queue) {
            if ((this.thread != null) && (queue != null)) {
  
            	for(KThread th: queue.waitQueue)
            	{
            		if(th == null)
            			break;
            		getThreadState(th).priority_need_change = true;
            	}
                queue.waitQueue.add(this.thread);
                this.time = Machine.timer().getTime();
            }
        }
        
        public void acquire(LotteryQueue queue) {
            if ((this.thread != null) && (queue != null)) {
                queue.current = this.thread;
                this.resources.add(queue);
                this.priority_need_change = true;
            }
        }
    }
}
