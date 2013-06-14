package nachos.threads;

import nachos.machine.*;

import java.util.*;

/**
 * Uses the hardware timer to provide preemption, and to allow threads to sleep
 * until a certain time.
 */
public class Alarm {
    /**
     * Allocate a new Alarm. Set the machine's timer interrupt handler to this
     * alarm's callback.
     *
     * <p><b>Note</b>: Nachos will not function correctly with more than one
     * alarm.
     */
    public Alarm() {
	Machine.timer().setInterruptHandler(new Runnable() {
		public void run() { timerInterrupt(); }
	    });
    }
    
    
	//create a priority queue to hold the alarm threads
	 private PriorityQueue<AlarmThread> queue = new PriorityQueue<AlarmThread>();
    
    //create AlarmThread class to hold the requesting Thread and corresponding time
    private class AlarmThread implements Comparable<AlarmThread>{
    	private KThread requestingThread;
    	private long sleepingTime;
    	
    	//Constructor
    	public AlarmThread(KThread thread, long time){
    		this.requestingThread = thread;
    		this.sleepingTime = time;
    	}
    	
    	public KThread getThread(){
    		if (this.requestingThread != null)
    			return this.requestingThread;
    		else
    			return null;
    	}
    	
    	public long getTime(){
    		return this.sleepingTime;
    	}
    	
    	@Override  
        public int compareTo(AlarmThread t) {  
            return (int)(getTime() - t.getTime());  
    	}
    }
    

    /**
     * The timer interrupt handler. This is called by the machine's timer
     * periodically (approximately every 500 clock ticks). Causes the current
     * thread to yield, forcing a context switch if there is another thread
     * that should be run.
     */
    public void timerInterrupt() {
    	
    	//for(i = Listofthreads.size() - 1; i >= 0 ; i--){
    		//long currTime = Machine.timer().getTime();
    		
    	while ((queue.peek()!=null) && (Machine.timer().getTime() >= queue.peek().getTime())){
    			queue.poll().getThread().ready();
    	}//end for
    	
    	KThread.currentThread().yield();
    }

    /**
     * Put the current thread to sleep for at least <i>x</i> ticks,
     * waking it up in the timer interrupt handler. The thread must be
     * woken up (placed in the scheduler ready set) during the first timer
     * interrupt where
     *
     * <p><blockquote>
     * (current time) >= (WaitUntil called time)+(x)
     * </blockquote>
     *
     * @param	x	the minimum number of clock ticks to wait.
     *
     * @see	nachos.machine.Timer#getTime()
     */
    public void waitUntil(long x) {
	// for now, cheat just to get something working (busy waiting is bad)
    	
    	Machine.interrupt().disable();
    	
    	long wakeTime = Machine.timer().getTime() + x;
    	
    	AlarmThread timingThread = new AlarmThread(KThread.currentThread(), wakeTime);
    	queue.add(timingThread);
		KThread.sleep();
		
		Machine.interrupt().enable();
    }
}
