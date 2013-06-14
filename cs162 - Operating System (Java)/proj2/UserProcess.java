package nachos.userprog;

import nachos.machine.*;
import nachos.threads.*;
import nachos.userprog.*;

import java.io.EOFException;
import java.util.ArrayList;

/**
 * Encapsulates the state of a user process that is not contained in its
 * user thread (or threads). This includes its address translation state, a
 * file table, and information about the program being executed.
 *
 * <p>
 * This class is extended by other classes to support additional functionality
 * (such as additional syscalls).
 *
 * @see	nachos.vm.VMProcess
 * @see	nachos.network.NetProcess
 */
public class UserProcess {
    /**
     * Allocate a new process.
     */
	
	//variables added for part I
	final int  MAX_FILE_DESCRIPTOR = 16;
    private boolean first = false;  // a boolean variable indicate the "root" process
	private static int num_process = 0; // store the number of processes
	private OpenFile[] files_descriptor; //support up to 16 concurrently open files per process
	
	//variables added for part III
	private int processID;
	private int exitStatus;
    private ArrayList<UserProcess> children;
    private UThread thisThread=null; 
    private static int concurrentThreads = 0;
    private UserProcess parent=null;
    private boolean normalExit = true;
	
	
    public UserProcess() {
	int numPhysPages = Machine.processor().getNumPhysPages();
	pageTable = new TranslationEntry[numPhysPages];
	for (int i=0; i<numPhysPages; i++)
	    pageTable[i] = new TranslationEntry(i,i, true,false,false,false);
    
    
	//part I
    if (num_process == 0)
    	first = true;
	// create new file tables
    files_descriptor = new OpenFile [MAX_FILE_DESCRIPTOR];
    /*
    for(int i = 0; i<MAX_FILE_DESCRIPTOR; i++)
		files_descriptor[i] = null;
    */
    files_descriptor[0] = UserKernel.console.openForReading(); // stdin
	files_descriptor[1] = UserKernel.console.openForWriting(); // stdout
	
	//part III
	processID = num_process;
	num_process += 1;
	children = new ArrayList<UserProcess>();
	
    }
    /**
     * Allocate and return a new process of the correct class. The class name
     * is specified by the <tt>nachos.conf</tt> key
     * <tt>Kernel.processClassName</tt>.
     *
     * @return	a new process of the correct class.
     */
    public static UserProcess newUserProcess() {
	return (UserProcess)Lib.constructObject(Machine.getProcessClassName());
    }

    /**
     * Execute the specified program with the specified arguments. Attempts to
     * load the program, and then forks a thread to run it.
     *
     * @param	name	the name of the file containing the executable.
     * @param	args	the arguments to pass to the executable.
     * @return	<tt>true</tt> if the program was successfully executed.
     */
    public boolean execute(String name, String[] args) {
	if (!load(name, args))
	    return false;
	
	thisThread = new UThread(this);
	thisThread.setName(name).fork();
	
	concurrentThreads++;
	//new UThread(this).setName(name).fork();

	return true;
    }

    /**
     * Save the state of this process in preparation for a context switch.
     * Called by <tt>UThread.saveState()</tt>.
     */
    public void saveState() {
    }

    /**
     * Restore the state of this process after a context switch. Called by
     * <tt>UThread.restoreState()</tt>.
     */
    public void restoreState() {
	Machine.processor().setPageTable(pageTable);
    }

    /**
     * Read a null-terminated string from this process's virtual memory. Read
     * at most <tt>maxLength + 1</tt> bytes from the specified address, search
     * for the null terminator, and convert it to a <tt>java.lang.String</tt>,
     * without including the null terminator. If no null terminator is found,
     * returns <tt>null</tt>.
     *
     * @param	vaddr	the starting virtual address of the null-terminated
     *			string.
     * @param	maxLength	the maximum number of characters in the string,
     *				not including the null terminator.
     * @return	the string read, or <tt>null</tt> if no null terminator was
     *		found.
     */
    public String readVirtualMemoryString(int vaddr, int maxLength) {
	Lib.assertTrue(maxLength >= 0);

	byte[] bytes = new byte[maxLength+1];

	int bytesRead = readVirtualMemory(vaddr, bytes);

	for (int length=0; length<bytesRead; length++) {
	    if (bytes[length] == 0)
		return new String(bytes, 0, length);
	}

	return null;
    }

    /**
     * Transfer data from this process's virtual memory to all of the specified
     * array. Same as <tt>readVirtualMemory(vaddr, data, 0, data.length)</tt>.
     *
     * @param	vaddr	the first byte of virtual memory to read.
     * @param	data	the array where the data will be stored.
     * @return	the number of bytes successfully transferred.
     */
    public int readVirtualMemory(int vaddr, byte[] data) {
	return readVirtualMemory(vaddr, data, 0, data.length);
    }

    /**
     * Transfer data from this process's virtual memory to the specified array.
     * This method handles address translation details. This method must
     * <i>not</i> destroy the current process if an error occurs, but instead
     * should return the number of bytes successfully copied (or zero if no
     * data could be copied).
     *
     * @param	vaddr	the first byte of virtual memory to read.
     * @param	data	the array where the data will be stored.
     * @param	offset	the first byte to write in the array.
     * @param	length	the number of bytes to transfer from virtual memory to
     *			the array.
     * @return	the number of bytes successfully transferred.
     */
    public int readVirtualMemory(int vaddr, byte[] data, int offset,
				 int length) {
	Lib.assertTrue(offset >= 0 && length >= 0 && offset+length <= data.length);

	byte[] memory = Machine.processor().getMemory();
	
	// for now, just assume that virtual addresses equal physical addresses
	if (vaddr < 0 || vaddr >= memory.length)
	    return 0;

	
	int vpoff = Processor.offsetFromAddress(vaddr);
	int PageUpperBound = (vaddr + length) / pageSize;
	int lengthLeft = length;
	int amount=0, physicalAddr, amountRead=0;
			
	for(int i = Processor.pageFromAddress(vaddr) ; i <= PageUpperBound && lengthLeft >0 ;i++){
			physicalAddr = Processor.makeAddress(pageTable[i].ppn, vpoff);
			amountRead = Math.min(lengthLeft, pageSize - vpoff);
			System.arraycopy(memory, physicalAddr, data, amount, amountRead);
			amount += amountRead;
			lengthLeft -= amountRead;
			
			vpoff = 0;
			pageTable[i].used = true;
	}

	return amount;
    }

    /**
     * Transfer all data from the specified array to this process's virtual
     * memory.
     * Same as <tt>writeVirtualMemory(vaddr, data, 0, data.length)</tt>.
     *
     * @param	vaddr	the first byte of virtual memory to write.
     * @param	data	the array containing the data to transfer.
     * @return	the number of bytes successfully transferred.
     */
    public int writeVirtualMemory(int vaddr, byte[] data) {
	return writeVirtualMemory(vaddr, data, 0, data.length);
    }

    /**
     * Transfer data from the specified array to this process's virtual memory.
     * This method handles address translation details. This method must
     * <i>not</i> destroy the current process if an error occurs, but instead
     * should return the number of bytes successfully copied (or zero if no
     * data could be copied).
     *
     * @param	vaddr	the first byte of virtual memory to write.
     * @param	data	the array containing the data to transfer.
     * @param	offset	the first byte to transfer from the array.
     * @param	length	the number of bytes to transfer from the array to
     *			virtual memory.
     * @return	the number of bytes successfully transferred.
     */
    public int writeVirtualMemory(int vaddr, byte[] data, int offset,
				  int length) {
	Lib.assertTrue(offset >= 0 && length >= 0 && offset+length <= data.length);

	byte[] memory = Machine.processor().getMemory();
	
	// for now, just assume that virtual addresses equal physical addresses
	if (vaddr < 0 || vaddr >= memory.length)
	    return 0;
	
	int vpoff = Processor.offsetFromAddress(vaddr);
	int PageUpperBound = (vaddr + length) / pageSize;
	int lengthLeft = length;
	int amount = 0, ppn, physicalAddr, amountWrote=0;
			
	for(int i = Processor.pageFromAddress(vaddr) ; i <= PageUpperBound && lengthLeft >0 ;i++){
			ppn = 0;
			if(pageTable[i].valid)
				ppn = pageTable[i].ppn; 
			else
	            Lib.debug(dbgProcess, "\taccessed wrong Page Table");
			amountWrote = Math.min(lengthLeft, pageSize - vpoff);
      
			physicalAddr = Processor.makeAddress(ppn, vpoff);
			if (!pageTable[i].readOnly){
	            System.arraycopy(data, amount, memory, physicalAddr, amountWrote);
	            pageTable[i].used = true;
	            pageTable[i].dirty = true;
	        }
			amount += amountWrote;
			lengthLeft -= amountWrote;
			vpoff = 0;
			}

	return amount;
    }

    /**
     * Load the executable with the specified name into this process, and
     * prepare to pass it the specified arguments. Opens the executable, reads
     * its header information, and copies sections and arguments into this
     * process's virtual memory.
     *
     * @param	name	the name of the file containing the executable.
     * @param	args	the arguments to pass to the executable.
     * @return	<tt>true</tt> if the executable was successfully loaded.
     */
    private boolean load(String name, String[] args) {
	Lib.debug(dbgProcess, "UserProcess.load(\"" + name + "\")");
	
	OpenFile executable = ThreadedKernel.fileSystem.open(name, false);
	if (executable == null) {
	    Lib.debug(dbgProcess, "\topen failed");
	    return false;
	}

	try {
	    coff = new Coff(executable);
	}
	catch (EOFException e) {
	    executable.close();
	    Lib.debug(dbgProcess, "\tcoff load failed");
	    return false;
	}

	// make sure the sections are contiguous and start at page 0
	numPages = 0;
	for (int s=0; s<coff.getNumSections(); s++) {
	    CoffSection section = coff.getSection(s);
	    if (section.getFirstVPN() != numPages) {
		coff.close();
		Lib.debug(dbgProcess, "\tfragmented executable");
		return false;
	    }
	    numPages += section.getLength();
	}

	// make sure the argv array will fit in one page
	byte[][] argv = new byte[args.length][];
	int argsSize = 0;
	for (int i=0; i<args.length; i++) {
	    argv[i] = args[i].getBytes();
	    // 4 bytes for argv[] pointer; then string plus one for null byte
	    argsSize += 4 + argv[i].length + 1;
	}
	if (argsSize > pageSize) {
	    coff.close();
	    Lib.debug(dbgProcess, "\targuments too long");
	    return false;
	}

	// program counter initially points at the program entry point
	initialPC = coff.getEntryPoint();	

	// next comes the stack; stack pointer initially points to top of it
	numPages += stackPages;
	initialSP = numPages*pageSize;

	// and finally reserve 1 page for arguments
	numPages++;

	if (!loadSections())
	    return false;

	// store arguments in last page
	int entryOffset = (numPages-1)*pageSize;
	int stringOffset = entryOffset + args.length*4;

	this.argc = args.length;
	this.argv = entryOffset;
	
	for (int i=0; i<argv.length; i++) {
	    byte[] stringOffsetBytes = Lib.bytesFromInt(stringOffset);
	    Lib.assertTrue(writeVirtualMemory(entryOffset,stringOffsetBytes) == 4);
	    entryOffset += 4;
	    Lib.assertTrue(writeVirtualMemory(stringOffset, argv[i]) ==
		       argv[i].length);
	    stringOffset += argv[i].length;
	    Lib.assertTrue(writeVirtualMemory(stringOffset,new byte[] { 0 }) == 1);
	    stringOffset += 1;
	}

	return true;
    }

    /**
     * Allocates memory for this process, and loads the COFF sections into
     * memory. If this returns successfully, the process will definitely be
     * run (this is the last step in process initialization that can fail).
     *
     * @return	<tt>true</tt> if the sections were successfully loaded.
     */
    protected boolean loadSections() {
	if (numPages > Machine.processor().getNumPhysPages()) {
	    coff.close();
	    Lib.debug(dbgProcess, "\tinsufficient physical memory");
	    return false;
	}
	for(int i=0; i<numPages; i++){            
        int ppn = ((UserKernel)Kernel.kernel).getFreePage();
        pageTable[i].ppn = ppn;
        pageTable[i].used = true;
    }
    
	// load sections
	for (int s=0; s<coff.getNumSections(); s++) {
	    CoffSection section = coff.getSection(s);
	    
	    Lib.debug(dbgProcess, "\tinitializing " + section.getName()
		      + " section (" + section.getLength() + " pages)");

	    for (int i=0; i<section.getLength(); i++) {
		int vpn = section.getFirstVPN()+i;
		
		pageTable[vpn].readOnly = section.isReadOnly();
        if (pageTable[vpn].vpn != vpn){
            return false;
        }
        
		section.loadPage(i, pageTable[vpn].ppn);
	    }
	}
	
	return true;
    }

    /**
     * Release any resources allocated by <tt>loadSections()</tt>.
     */
    protected void unloadSections() {
    	// part II
    	for(int i = 0; i < numPages; i++)
            ((UserKernel)Kernel.kernel).FreePage(this.pageTable[i].ppn);
    }    

    /**
     * Initialize the processor's registers in preparation for running the
     * program loaded into this process. Set the PC register to point at the
     * start function, set the stack pointer register to point at the top of
     * the stack, set the A0 and A1 registers to argc and argv, respectively,
     * and initialize all other registers to 0.
     */
    public void initRegisters() {
	Processor processor = Machine.processor();

	// by default, everything's 0
	for (int i=0; i<processor.numUserRegisters; i++)
	    processor.writeRegister(i, 0);

	// initialize PC and SP according
	processor.writeRegister(Processor.regPC, initialPC);
	processor.writeRegister(Processor.regSP, initialSP);

	// initialize the first two argument registers to argc and argv
	processor.writeRegister(Processor.regA0, argc);
	processor.writeRegister(Processor.regA1, argv);
    }

    /**
     * Handle the halt() system call. 
     */
    private int handleHalt() {
    	
    if (!first)
    	return -1;

	Machine.halt();
	
	Lib.assertNotReached("Machine.halt() did not halt machine!");
	return 0;
    }


    private static final int
        syscallHalt = 0,
	syscallExit = 1,
	syscallExec = 2,
	syscallJoin = 3,
	syscallCreate = 4,
	syscallOpen = 5,
	syscallRead = 6,
	syscallWrite = 7,
	syscallClose = 8,
	syscallUnlink = 9;

    /**
     * Handle a syscall exception. Called by <tt>handleException()</tt>. The
     * <i>syscall</i> argument identifies which syscall the user executed:
     *
     * <table>
     * <tr><td>syscall#</td><td>syscall prototype</td></tr>
     * <tr><td>0</td><td><tt>void halt();</tt></td></tr>
     * <tr><td>1</td><td><tt>void exit(int status);</tt></td></tr>
     * <tr><td>2</td><td><tt>int  exec(char *name, int argc, char **argv);
     * 								</tt></td></tr>
     * <tr><td>3</td><td><tt>int  join(int pid, int *status);</tt></td></tr>
     * <tr><td>4</td><td><tt>int  creat(char *name);</tt></td></tr>
     * <tr><td>5</td><td><tt>int  open(char *name);</tt></td></tr>
     * <tr><td>6</td><td><tt>int  read(int fd, char *buffer, int size);
     *								</tt></td></tr>
     * <tr><td>7</td><td><tt>int  write(int fd, char *buffer, int size);
     *								</tt></td></tr>
     * <tr><td>8</td><td><tt>int  close(int fd);</tt></td></tr>
     * <tr><td>9</td><td><tt>int  unlink(char *name);</tt></td></tr>
     * </table>
     * 
     * @param	syscall	the syscall number.
     * @param	a0	the first syscall argument.
     * @param	a1	the second syscall argument.
     * @param	a2	the third syscall argument.
     * @param	a3	the fourth syscall argument.
     * @return	the value to be returned to the user.
     */
    
    
 //*****************methods added for part 1 ****************************
    //create
    private int handleCreate(String filename){
    	if (filename == null)    //filename does not exist
    		return -1;
    	for(int i = 2; i<MAX_FILE_DESCRIPTOR; i++)
    		if (files_descriptor[i] == null){
    			files_descriptor[i] = ThreadedKernel.fileSystem.open(filename, true);
    			if (files_descriptor[i] == null)
    				return -1;
    			return i;
    		}
    	return -1; // there is no file descriptor available
    }
    
    
    //open
    private int handleOpen(String filename){
    	if (filename == null)    //filename does not exist
    		return -1;
    	for(int i = 2; i<MAX_FILE_DESCRIPTOR; i++)
    		if (files_descriptor[i] == null){
    			files_descriptor[i] = ThreadedKernel.fileSystem.open(filename, false);  // no need to create a file
    			if (files_descriptor[i] == null)
    				return -1;
    			return i;
    		}
    	return -1; // there is no file descriptor available 
    }
    
    
    //read
    private int handleRead(int descriptor_index, int vaddr, int count){
    	// parameter check, any error occur will return -1
    	if (vaddr < 0 || descriptor_index < 0 || descriptor_index >= MAX_FILE_DESCRIPTOR || count < 0)
    		return -1;
    	OpenFile readfile = files_descriptor[descriptor_index];
    	byte[] buffer = new byte[count] ;  //  read one page, write a page
    	if (readfile == null) return -1;
    	int num_read_byte = readfile.read(buffer, 0, count) ; // this is the real number of byte read from file
    	if (num_read_byte < 0) return -1;
    	int num_write_byte = this.writeVirtualMemory(vaddr, buffer, 0, num_read_byte);
    	if (num_write_byte != num_read_byte){
    		files_descriptor[descriptor_index] = null;
    		return -1;
    	}
    	
    	return num_read_byte;
    }
    
    //write
    private int handleWrite(int descriptor_index, int vaddr, int count){
    	// parameter check, any error occur will return -1
    	if (vaddr < 0 || descriptor_index < 0 || descriptor_index >= MAX_FILE_DESCRIPTOR || count < 0)
    		return -1;
    	OpenFile writefile = files_descriptor[descriptor_index];
    	byte[] buffer = new byte[count];
    	if (writefile == null) return -1;
    	int num_read_byte = this.readVirtualMemory(vaddr, buffer, 0, count);
    	if (num_read_byte < 0) return -1;
    	int num_write_byte = writefile.write(buffer, 0, count);
    	if(num_write_byte != count){
    		files_descriptor[descriptor_index] = null;
    		return -1;
    	}
    	
    	return num_write_byte;
    }
    
    //close
    private int handleClose(int descriptor_index){
    	// parameter check, any error occur will return -1
    	if (descriptor_index < 0 || descriptor_index >= MAX_FILE_DESCRIPTOR)
    		return -1;
    	if (files_descriptor[descriptor_index]==null)
    		return -1;
    	files_descriptor[descriptor_index].close();
    	files_descriptor[descriptor_index] = null;
    	return 0;
    }
    
    //unlink
    private int handleUnlink(String fileName){
    	if (fileName == null)
    		return -1;
    	ThreadedKernel.fileSystem.remove(fileName);
    	return 0;
    }
    
    //------------------------------part III---------------------------------------------------
    //exec
    private int handleExec(String filename, int argCount, int arguments){
  
    	//terminated if file name is empty or file does not end with .coff or negative argCount
    	if(argCount < 0 || filename == null || filename.endsWith(".coff") == false) return -1;
    	
    	int numberOfBytesInArguments=0, numberOfBytesTransferred=0;
    	byte[] theByteArrayOfAddrToArgs;
    	String[] argStrings = new String[argCount];
    	String result;
    	
    	if (argCount!=0){
    	numberOfBytesInArguments = argCount * 4;
    	theByteArrayOfAddrToArgs = new byte[numberOfBytesInArguments];
    	numberOfBytesTransferred=readVirtualMemory(arguments,theByteArrayOfAddrToArgs,0,numberOfBytesInArguments);
    
    	if(numberOfBytesTransferred != numberOfBytesInArguments) return -1;
     
    	//By now, we have theByteArrayOfAddrToArgs, we need to convert content inside this array into an array of 
    	//string argument. As defined, each argument is 4 bytes, so we read 4 bytes by 4 bytes from 
    	//theByteArrayOfAddrToArgs and then convert them to string. Implementations are as follow:

    	int i=0;
    	while (i<argCount){
    		result =readVirtualMemoryString(Lib.bytesToInt(theByteArrayOfAddrToArgs,i*4),256);

    		if (result == null) return -1;
    		
    		argStrings[i] = result;
    		i++;
    	}
    	//if the result is not the same as we expected
    	if(argStrings.length != argCount) return -1;
    	}
    	
		UserProcess child = new UserProcess();
    	child.parent = this;
    	
    	//if the child can be successfully executed, return the processID, return -1 otherwise 
    	if (child.execute(filename, argStrings)){
    		children.add(child);
   			return child.processID;
    	}
    	else
    		return -1; // if child is not successfully executed then return an error
	}
	
	//join
	private int handleJoin(int processID, int status){
		boolean isChild = false;
		UserProcess childProcess = null;
		int i=0;
		
		while (i<children.size()){
			childProcess = children.get(i);
			if(childProcess != null && childProcess.processID == processID){
				isChild = true;
				break;
			}
			i++;
		}
		if(!isChild) return -1;
		
		childProcess.thisThread.join();
		children.remove(childProcess);
		
		byte[] childExitStatus = Lib.bytesFromInt(childProcess.exitStatus);
   		
   		if(writeVirtualMemory(status,childExitStatus) != 4)
   			return -1;
   		
       	if(childProcess.normalExit == true)
       		return 1;
       	else
       		return 0;
	}
	
	//exit
    private void handleExit(int status)
    {
    	for (int i=0;i<MAX_FILE_DESCRIPTOR;i++){
    		handleClose(i);
    	}
    	
    	UserProcess childProcess = null;
    	int i=0;
    	while (i<children.size()){
			childProcess = children.get(i);
			if(childProcess != null){
				childProcess.parent = null;
			}
			i++;
		}
    	
    	unloadSections();
    	exitStatus = status;
    	if(concurrentThreads == 1)         //terminate if the last process
    		Kernel.kernel.terminate();
    	else
    	{
    		concurrentThreads -= 1;
    		thisThread.finish();
    	}	
    }

 //**********************************************************************/
    public int handleSyscall(int syscall, int a0, int a1, int a2, int a3) {
    	String filename = null;
	switch (syscall) {
	case syscallHalt:
		if (this.first == true) return handleHalt();
		else return -1;
	case syscallCreate:
		filename = readVirtualMemoryString(a0, 256);  //get file name from memory
    	return handleCreate(filename);
	case syscallOpen:
	    filename = readVirtualMemoryString(a0, 256);  //get file name from memory
	    return handleOpen(filename);
	case syscallRead:
		return handleRead(a0,a1,a2);
	case syscallWrite:
		return handleWrite(a0,a1,a2);
	case syscallClose:
		return handleClose(a0);
	case syscallUnlink:
		filename = readVirtualMemoryString(a0, 256);  //get file name from memory
		return handleUnlink(filename);
	    		
	// part III
	case syscallExec:
		filename = readVirtualMemoryString(a0,256);
		return handleExec(filename, a1, a2);
	case syscallJoin:
		return handleJoin(a0,a1);
	case syscallExit: 
		handleExit(a0);
		return 0;



	default:
	    Lib.debug(dbgProcess, "Unknown syscall " + syscall);
	    Lib.assertNotReached("Unknown system call!");
	}
	return 0;
    }

    /**
     * Handle a user exception. Called by
     * <tt>UserKernel.exceptionHandler()</tt>. The
     * <i>cause</i> argument identifies which exception occurred; see the
     * <tt>Processor.exceptionZZZ</tt> constants.
     *
     * @param	cause	the user exception that occurred.
     */
    public void handleException(int cause) {
	Processor processor = Machine.processor();

	switch (cause) {
	case Processor.exceptionSyscall:
	    int result = handleSyscall(processor.readRegister(Processor.regV0),
				       processor.readRegister(Processor.regA0),
				       processor.readRegister(Processor.regA1),
				       processor.readRegister(Processor.regA2),
				       processor.readRegister(Processor.regA3)
				       );
	    processor.writeRegister(Processor.regV0, result);
	    processor.advancePC();
	    break;				       
				       
	default:
		
		
	    Lib.debug(dbgProcess, "Unexpected exception: " +
		      Processor.exceptionNames[cause]);
	    Lib.assertNotReached("Unexpected exception");
	    normalExit = false;
	    handleExit(1);
	}
    }

    /** The program being run by this process. */
    protected Coff coff;

    /** This process's page table. */
    protected TranslationEntry[] pageTable;
    /** The number of contiguous pages occupied by the program. */
    protected int numPages;

    /** The number of pages in the program's stack. */
    protected final int stackPages = 8;
    
    private int initialPC, initialSP;
    private int argc, argv;
	
    private static final int pageSize = Processor.pageSize;
    private static final char dbgProcess = 'a';
}
