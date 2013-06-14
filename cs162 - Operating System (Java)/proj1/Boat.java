package nachos.threads;
import nachos.ag.BoatGrader;

public class Boat {

	static BoatGrader bg; 				
	static int Adults_on_Oahu;			//Number of adults on Oahu
	static int Adults_on_Molokai;		//Number of adults on Molokai
	static int Children_on_Oahu;		//Number of children on Oahu
	static int Children_on_Molokai;		//Number of children on Molokai
	static boolean Boat_on_Oahu;		//Boolean specifying if boat in on Oahu
	static boolean Child_Boat_Pilot;	//Boolean specifying if child is the pilot
	static Lock Start_Lock;				//Lock held by begin() thread
	static Lock People_Lock;			//Lock held by adult and child threads
	static Condition Completed;			//Condition variable for begin() thread
	static Condition Oahu_Adults;		//Condition variable for Oahu adults
	static Condition Molokai_Adults;	//Condition variable for Molokai adults
	static Condition Oahu_Children;		//Condition variable for Oahu children
	static Condition Molokai_Children;	//Condition variable for Molokai children
	static Alarm Check_Alarm;			//Alarm for child thread to check if all adults and children are transported to Molokai
	
    public static void selfTest()
    {
	BoatGrader b = new BoatGrader();
	
	System.out.println("\n ***Testing Boats with only 2 children***");
	begin(0, 2, b);

//	System.out.println("\n ***Testing Boats with 2 children, 1 adult***");
//  	begin(1, 2, b);

//  	System.out.println("\n ***Testing Boats with 3 children, 3 adults***");
//  	begin(3, 3, b);
    }
    
	public static void begin (int adults, int children, BoatGrader boat_grader){
		bg = boat_grader;
		
		//Initialize variables
		Adults_on_Oahu = 0;
		Adults_on_Molokai = 0;
		Children_on_Oahu = 0;
		Children_on_Molokai = 0;
		Boat_on_Oahu = true;
		Child_Boat_Pilot = false;
		Start_Lock = new Lock();
		People_Lock = new Lock();
		Completed = new Condition(Start_Lock);
		Oahu_Adults = new Condition(People_Lock);
		Molokai_Adults = new Condition(People_Lock);
		Oahu_Children = new Condition(People_Lock);
		Molokai_Children = new Condition(People_Lock);
		Check_Alarm = new Alarm();
		
		//Acquire Lock first before execution
		Start_Lock.acquire();
		
		//Create adult threads
		for(int a_threads = 0; a_threads < adults; a_threads ++){
			Runnable run_thread = new Runnable(){
				public void run(){
					AdultItinerary();
				}
			};
			KThread k_thread = new KThread(run_thread);
			k_thread.setName("Adult Thread");
			//Execute thread
			k_thread.fork();		
		}
		
		//Create children threads
		for(int c_threads = 0; c_threads < children; c_threads ++){
			Runnable run_thread = new Runnable(){
				public void run(){
					ChildItinerary();
				}
			};
			KThread k_thread = new KThread(run_thread);
			k_thread.setName("Children Thread");
			//Execute thread
			k_thread.fork();
		}
		
		//sleep until the children thread thinks the problem is solved. 
		//Children thread will then wake it up to do a check until the problem is actuall resolved
		Completed.sleep();
		
		//Checks if a solution is found. Otherwise, it will keep sleeping
		while(Adults_on_Molokai != adults && Children_on_Molokai != children){
			Completed.sleep();
		}
	}
	
    static void AdultItinerary()
    {
	/* This is where you should put your solutions. Make calls
	   to the BoatGrader to show that it is synchronized. For
	   example:
	       bg.AdultRowToMolokai();
	   indicates that an adult has rowed the boat across to Molokai
	*/
    	People_Lock.acquire();		//acquire lock before making changes
    	Adults_on_Oahu ++;			//increment the number of adults on Oahu when the thread runs 
    	Oahu_Adults.sleep();		//Sleep adult threads

    	while(true){
    		if(Boat_on_Oahu){
    			Row_Adult_To_Molokai();		//Calls the function to row an adult to Molokai
    		}
    		else{
    			Oahu_Adults.sleep();		//If the boat is not at Oahu, adults at Oahu can't do anything so goes to sleep
    		}
    	}
    }
    
    static void Row_Adult_To_Molokai(){
    	bg.AdultRowToMolokai();		//Adult rows to Molokai
    	Boat_on_Oahu = false;		//Boat no longer on Oahu
    	Adults_on_Oahu --;			//Decrement the number of adults on Oahu
    	Adults_on_Molokai ++;		//Increment the number of adults on Molokai
    	Molokai_Children.wake();	//A child from Molokai has to row the boat back to Oahu
    	Molokai_Adults.sleep();		//Adult who reaches Molokai goes to sleep and no longer have to do anything else
    }

    static void ChildItinerary()
    {
    	boolean Child_on_Oahu = true;	//Child originally starts from Oahu
    	People_Lock.acquire();			//acquire lock before making changes
    	Children_on_Oahu ++;			//increment the number of children on Oahu when the thread runs
    	
    	//Have at least 2 children on Oahu before starting to row the boat over to Molokai
    	if(Children_on_Oahu < 2){
    		Oahu_Children.sleep();
    	}
    	
    	//Goes into infinite loop
    	while(true){
    		if(Child_on_Oahu){	//Check if child is on Oahu
    			if(!Boat_on_Oahu){			//If boat is not on Oahu, children on Oahu goes to sleep
    				Oahu_Children.sleep();
    			}
    			else{
    				if(Children_on_Oahu >= 2){		//If there is at least 2 children on Oahu
    					if(Child_Boat_Pilot){		//If there is a child who is going to pilot the boat
    						bg.ChildRideToMolokai();
    						Child_on_Oahu = false;	//Current child no longer on Oahu
    						child_pilots_boat();	//Thread checks that there is another child thread waiting to be pilot and hops in to be passenger
    					}
    					else{
    						bg.ChildRowToMolokai();
    						Child_on_Oahu = false;	//Current child no longer on Oahu
    						child_becomes_boat_pilot();
    					}
    				}
    				else{
    					if(Adults_on_Oahu > 0){		//There are less than 2 children on Oahu but there are still adults on Oahu
    						Oahu_Adults.wake();		//Adult rows to Molokai
    						Oahu_Children.sleep();	//Children on Oahu goes to sleep
    					}
    					else{
    						bg.ChildRowToMolokai();	//Child rows to Molokai since there are no adults on Oahu and he is the only child on Oahu
    						Child_on_Oahu = false;		//Child no longer on Oahu
    						check_for_completion();		//Rows back to Molokai and wake up begin() thread to check if problem is fixed. Then row back to Oahu so another check will be executed later on, in case there is any inactive threads previously   						
    						Child_on_Oahu = true;		//Child is now on Oahu
    					}
    				}
    			}
    		}
    		else{		//Child is on Molokai
    			if(Boat_on_Oahu){	//Boat is on Oahu, conditional variable, Molokai_Children, goes to sleep
    				Molokai_Children.sleep();
    			}
    			else{
    				bg.ChildRowToOahu();	//Child rows to Oahu
    				Child_on_Oahu = true;	//Child is now in Oahu
    				row_to_Oahu(); 		//Child rides to Oahu and either wakes up an adult thread or children thread, depending on the number of children left on Molokai
    			} 			
    		}
    	}
    }
    
    static void child_pilots_boat(){
    	
        Boat_on_Oahu = !Boat_on_Oahu;   // Boat changes location after rowing
        Children_on_Oahu -= 2;       	// Decrement the number of children on Oahu by 2, 1 child pilot and 1 child passenger
        Children_on_Molokai += 2;    	// Increment the number of children on Molokai by 2
        Child_Boat_Pilot = false;      	// There is no longer a child waiting to pilot the boat
        Molokai_Children.wake();        // Wake up a child on Molokai to row the boat back to Oahu
        Molokai_Children.sleep();       // Sleep on Molokai_Children after the child rowed back to Oahu
    }

    static void child_becomes_boat_pilot(){
    	
    	Child_Boat_Pilot = true;	    // Current child becomes pilot of the boat
        Oahu_Children.wake();           // Wake up a Oahu child to ride as the passenger
        Molokai_Children.sleep();       // Sleep on Molokai_Children after the child reaches Molokai
    }
    
    static void check_for_completion(){
		Boat_on_Oahu = false;		//Boat gets rowed to Molokai
		Children_on_Oahu --;		//Decrement number of children on Oahu
		Children_on_Molokai ++;		//Increment number of children on Molokai
		Start_Lock.acquire();		//Acquire the start lock for begin()
		Completed.wake();			//Wake up the condition variable, Completed
		Start_Lock.release();		//Release the lock for begin()
		People_Lock.release();		//Release the lock for Adult and Child Itinerary so inactive threads can execute now
		Check_Alarm.waitUntil(99); //Sleep for a little while before checking again
		People_Lock.acquire();		//Acquire the lock for Adult and Child Itinerary
		bg.ChildRowToOahu();		//Child rows back to Oahu
		Boat_on_Oahu = true;		//Boat is back on Oahu
		Children_on_Oahu ++;		//Increment the number of children on Oahu
		Children_on_Molokai --;		//Decrement the number of children on Molokai
    }
    
    static void row_to_Oahu(){
    	Boat_on_Oahu = true;	//Boat is now in Oahu
		Children_on_Oahu ++;	//Increment the number of children in Oahu
		Children_on_Molokai --;	//Decrement the number of children in Molokai
		
		if(Children_on_Molokai > 0){	//If there are still children on Molokai when current child rows to Oahu
			if(Adults_on_Oahu > 0){		//There are adults on Oahu and children on Molokai
				Oahu_Adults.wake();		//Wake up an adult thread and row to Molokai
				Oahu_Children.sleep();	//Oahu children goes to sleep while the adult rows to Molokai
			}
		}
		else{
			Oahu_Children.wake();		//Wake up an Oahu child to row back to Molokai since there is no children left in Molokai
			Oahu_Children.sleep();		
		}
    }
    
    static void SampleItinerary()
    {
	// Please note that this isn't a valid solution (you can't fit
	// all of them on the boat). Please also note that you may not
	// have a single thread calculate a solution and then just play
	// it back at the autograder -- you will be caught.
	System.out.println("\n ***Everyone piles on the boat and goes to Molokai***");
	bg.AdultRowToMolokai();
	bg.ChildRideToMolokai();
	bg.AdultRideToMolokai();
	bg.ChildRideToMolokai();
    }
}
