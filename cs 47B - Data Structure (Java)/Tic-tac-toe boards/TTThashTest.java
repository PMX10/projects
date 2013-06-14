import java.io.*;
import java.util.Hashtable;

public class TTThashTest {

    public static void main (String [ ] args) {
    	Hashtable table = new Hashtable();
        long startTime = System.currentTimeMillis ( );
        
        /*
         	There are total 3^9 = 19683 possible board combinations
        */
        for (int k=0; k<19683; k++) {
            TTTboard b = new TTTboard (k);
            table.put (b, new Integer (k));
        }
        long finishTime = System.currentTimeMillis ( );
        System.out.println ("Time to insert all Tic-tac-toe boards = "
            + (finishTime-startTime));
    }
}

