import java.io.*;
//import java.util.*;

public class HashTest {

    static BufferedReader reader (String fileName) throws Exception {
        File wordFile;
        FileInputStream wordFileStream;
        InputStreamReader wordsIn; 
        
        wordFile = new File (fileName);
        wordFileStream = new FileInputStream (wordFile);
        wordsIn = new InputStreamReader (wordFileStream);
        return new BufferedReader (wordsIn);
    }

	// Arguments are the file of words and the table size.
    public static void main (String [ ] args) throws Exception {
        /*
    	if (args.length != 2) {
            System.err.println ("Wrong number of arguments.");
            System.exit (1);
        }
        */
        String a = new String("D:\\47b\\HashExercise\\src\\words.txt");
        
        for(int tableSize = 1040; tableSize<1051; tableSize++)
        {
        BufferedReader wordReader;
        //int tableSize = Integer.parseInt (args[1]);
        Hashtable table = new Hashtable (tableSize);
        String word;

		// Read all the words into the hash table.
        int wordCount = 0;
        wordReader = reader (a);
        do {
            try {
                word = wordReader.readLine ();
            } catch (Exception e) {
                System.err.println (e.getMessage());
                break;
            }
            if (word == null) {
                break;
            } else {
                wordCount++;
                table.put (word, new Integer(wordCount));
            }
        } while (true);
        
        // Now look up all the words.
        wordReader = reader (a);
        long startTime = System.currentTimeMillis ( );
        do {
            try {
                word = wordReader.readLine ();
            } catch (Exception e) {
                System.err.println (e.getMessage());
                break;
            }
            if (word == null) {
                break;
            } else {
                boolean result = table.containsKey (word);
            }
        } while (true);
        long finishTime = System.currentTimeMillis ( );
        System.out.println("Table Size:" + tableSize);
        System.out.println ("Time to hash " + wordCount + " words is " 
            + (finishTime-startTime) + " milliseconds.");
        table.printStatistics ( );
        
        System.out.println();
        System.out.println();
        }
    }
}


