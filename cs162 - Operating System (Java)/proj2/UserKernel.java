package nachos.userprog;

import java.util.LinkedList;
import java.util.*;
import nachos.machine.*;
import nachos.threads.*;
import nachos.userprog.*;

/**
 * A kernel that can support multiple user processes.
 */
public class UserKernel extends ThreadedKernel {
    /**
     * Allocate a new user kernel.
     */
	
	private LinkedList<PageInfo> freePageList = new LinkedList<PageInfo>();
    private Lock lock;
    private int numberOfPages;
	
    private class PageInfo
    {
    	private int pageNumber = 0;
    	private boolean isFree = true;	
    	
    	public PageInfo(int p, boolean f){
    		this.pageNumber = p;
    		this.isFree = f;
    	}
    	
    	public int getPageNumber(){
    		return this.pageNumber;
    	}
    	
    	public void setPageNumber(int p){
    		this.pageNumber = p;
    	}
    	
    	public void setFree(boolean f){
    		this.isFree = f;
    	}
    	
    	public boolean free(){
    		return this.isFree;
    	}
    }
    
    public UserKernel() {
	super();
    }

    /**
     * Initialize this kernel. Creates a synchronized console and sets the
     * processor's exception handler.
     */
    public void initialize(String[] args) {
	super.initialize(args);

	console = new SynchConsole(Machine.console());
	
	Machine.processor().setExceptionHandler(new Runnable() {
		public void run() { exceptionHandler(); }
	    });
	
	// initialize for all pages
	lock = new Lock();
	lock.acquire();
	numberOfPages = Machine.processor().getNumPhysPages();
	int i = 0;
	while(i < numberOfPages){
		PageInfo page = new PageInfo(i, true);
		freePageList.add(page);
		i++;
	}
	lock.release();
	
	
    }

    /**
     * Test the console device.
     */	
    public void selfTest() {
	super.selfTest();

	System.out.println("Testing the console device. Typed characters");
	System.out.println("will be echoed until q is typed.");

	char c;

	do {
	    c = (char) console.readByte(true);
	    console.writeByte(c);
	}
	while (c != 'q');

	System.out.println("");
    }

    /**
     * Returns the current process.
     *
     * @return	the current process, or <tt>null</tt> if no process is current.
     */
    public static UserProcess currentProcess() {
	if (!(KThread.currentThread() instanceof UThread))
	    return null;
	
	return ((UThread) KThread.currentThread()).process;
    }

    /**
     * The exception handler. This handler is called by the processor whenever
     * a user instruction causes a processor exception.
     *
     * <p>
     * When the exception handler is invoked, interrupts are enabled, and the
     * processor's cause register contains an integer identifying the cause of
     * the exception (see the <tt>exceptionZZZ</tt> constants in the
     * <tt>Processor</tt> class). If the exception involves a bad virtual
     * address (e.g. page fault, TLB miss, read-only, bus error, or address
     * error), the processor's BadVAddr register identifies the virtual address
     * that caused the exception.
     */
    public void exceptionHandler() {
	Lib.assertTrue(KThread.currentThread() instanceof UThread);

	UserProcess process = ((UThread) KThread.currentThread()).process;
	int cause = Machine.processor().readRegister(Processor.regCause);
	process.handleException(cause);
    }

    /**
     * Start running user programs, by creating a process and running a shell
     * program in it. The name of the shell program it must run is returned by
     * <tt>Machine.getShellProgramName()</tt>.
     *
     * @see	nachos.machine.Machine#getShellProgramName
     */
    public void run() {
	super.run();

	UserProcess process = UserProcess.newUserProcess();
	
	String shellProgram = Machine.getShellProgramName();	
	Lib.assertTrue(process.execute(shellProgram, new String[] { }));

	KThread.currentThread().finish();
    }

    /**
     * Terminate this kernel. Never returns.
     */
    public void terminate() {
	super.terminate();
    }
    
    //********************part 2*************************


    public int getFreePage(){
    	int PageNumber;
    	lock.acquire();
    	int i =0;
    	while( i < numberOfPages){
    		if (freePageList.get(i).free()){
    			PageNumber = freePageList.get(i).getPageNumber();
    			freePageList.get(i).setFree(false); //remove unfree pages
    			lock.release();
    			return PageNumber;
    		}
    		i++;
          }
    	lock.release();
    	return -1;
    }
    
    public void FreePage(int pageNum){
    	lock.acquire();
    	if (pageNum <= freePageList.size() && pageNum >=0)
    			freePageList.get(pageNum).setFree(true);
    	else
            Lib.debug(dbgProcess, "page number is out of range");
    	
     	lock.release();
    }
    
    //***************************************************

    /** Globally accessible reference to the synchronized console. */
    public static SynchConsole console;
    private static final char dbgProcess = 'a';
    // dummy variables to make javac smarter
    private static Coff dummy1 = null;
}
