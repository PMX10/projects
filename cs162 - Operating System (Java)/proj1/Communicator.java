package nachos.threads;

import nachos.machine.*;

/**
 * A <i>communicator</i> allows threads to synchronously exchange 32-bit
 * messages. Multiple threads can be waiting to <i>speak</i>,
 * and multiple threads can be waiting to <i>listen</i>. But there should never
 * be a time when both a speaker and a listener are waiting, because the two
 * threads can be paired off at this point.
 */
public class Communicator {
    
	private static boolean isEmpty;
	private static Condition2 speak_condition, listen_condition, finish_condition;
	private int buf;
	//private static int speakers, listeners;
    private Lock lock;
    
	/**
     * Allocate a new communicator.
     */
    public Communicator() {
    	isEmpty = true;
    	lock = new Lock();
    	speak_condition = new Condition2(lock);
    	listen_condition = new Condition2(lock);
    	finish_condition = new Condition2(lock);
    	setBuf(0);
    	//speakers = 0;
    	//listeners = 0;
    }

    /**
     * Wait for a thread to listen through this communicator, and then transfer
     * <i>word</i> to the listener.
     *
     * <p>
     * Does not return until this thread is paired up with a listening thread.
     * Exactly one listener should receive <i>word</i>.
     *
     * @param	word	the integer to transfer.
     */
    public void setBuf(int b){
    	this.buf = b;
    }
    
    public int getBuf(){
    	return this.buf;
    }
    
    
    
    public void speak(int word) {
    	lock.acquire();
        while (isEmpty == false ){
            listen_condition.wake();
            speak_condition.sleep();            
        }
        
        isEmpty = false;
        setBuf(word);
        listen_condition.wake();
        finish_condition.sleep();
        lock.release();
    }

    /**
     * Wait for a thread to speak through this communicator, and then return
     * the <i>word</i> that thread passed to <tt>speak()</tt>.
     *
     * @return	the integer transferred.
     */    
    public int listen() {
    	 int returnWord;
	     lock.acquire();
	     while (isEmpty == true){
	    	 speak_condition.wake();
	    	 listen_condition.sleep();
	     }
	     isEmpty = true;
	     returnWord = getBuf();
	     finish_condition.wake();
	     lock.release();
	     return returnWord;
    }


	
}
