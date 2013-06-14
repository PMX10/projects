import java.io.*;

public class TTTboard {

    private StringBuffer myBoard;

    // Initialize a blank Tic-tac-toe board.
    public TTTboard ( ) {
        myBoard = new StringBuffer ("         ");
    }
    
    // Initialize a Tic-tac-toe board from the given value
    // by interpreting the value in base 3 and representing
    // a 0 as a blank, a 1 as an X, and a 2 as an O.
    public TTTboard (int base3) {
	myBoard = new StringBuffer ("         ");
        for (int k=8; k>=0; k--) {
            int digit = base3 % 3;
            switch (digit) {
            case 0:
                myBoard.setCharAt (k, BLANK); 
                break;
            case 1: 
                myBoard.setCharAt (k, 'X'); 
                break;
            case 2:
                myBoard.setCharAt (k, 'O'); 
                break;
            }
            base3 = base3/3;
        }
    }
    
    final char BLANK = ' ';
    
    // Handle a player's move.
    // If player1isMoving, the move is 'x', otherwise it's 'o'.
    // row and column are 1-based, not zero-based.
    // If the chosen move isn't blank, print an error message
    // and don't do anything.
    public void makeMove (boolean player1isMoving, int row, int col) {
        int index = stringIndex (row, col);
        if (myBoard.charAt(index) == BLANK) {
            System.err.println ("Can't move to " + row + "," + col
                + "; move already made.");
        } else if (player1isMoving) {
            myBoard.setCharAt (index, 'X');
        } else {
            myBoard.setCharAt (index, 'O');
        }
    }
    
    // Determine if the move just made was a winner, that is,
    // created three in a row of whoever moved.
    public boolean wins (int row, int col) {
        switch (row) {
        case 1:
            switch (col) {
            case 1: return allMatch (0, 1, 2) || allMatch (0, 3, 6) || allMatch (0, 4, 8);
            case 2: return allMatch (0, 1, 2) || allMatch (1, 4, 7);
            case 3: return allMatch (0, 1, 2) || allMatch (2, 5, 8) || allMatch (2, 4, 6);
            }
        case 2:
            switch (col) {
            case 1: return allMatch (3, 4, 5) || allMatch (0, 3, 6);
            case 2: return allMatch (3, 4, 5) || allMatch (1, 4, 7)
                || allMatch (0, 4, 8) || allMatch (2, 4, 6);
            case 3: return allMatch (3, 4, 5) || allMatch (2, 5, 8);
            }
        case 3:
            switch (col) {
            case 1: return allMatch (6, 7, 8) || allMatch (0, 3, 6) || allMatch (2, 4, 6);
            case 2: return allMatch (6, 7, 8) || allMatch (1, 4, 7);
            case 3: return allMatch (6, 7, 8) || allMatch (2, 5, 8) || allMatch (0, 4, 8);
            }
        }
		return false;
    }
        
    // Return the translation of people coordinates (row between 1 and 3,
    // col between 1 and 3) to internal board position.
    private static int stringIndex (int row, int col) {
        return (row-1)*3 + (col-1);
    }
    
    // a, b, and c represent the internal coordinates of the elements
    // of a row, column, or diagonal of the board, at least one of which
    // is nonblank.  Return true if they all match.
    private boolean allMatch (int a, int b, int c) {
        return myBoard.charAt (a) == myBoard.charAt (b)
            && myBoard.charAt (b) == myBoard.charAt (c);
    }
    
    public void print ( ) {
        for (int r=1; r<=3; r++) {
            for (int c=1; c<=3; c++) {
                System.out.print (myBoard.charAt (stringIndex(r,c)));
            }
            System.out.println ("");
        }
    }
    
    //Code added
    
    //provide toString() function to TTTboard
    public String toString(){
    	return myBoard.toString();
    }
    
    // overwrite equals() function in Hashtable class
    public boolean equals(TTTboard other){
    	return other.toString().equals(toString());
    }
    
    // overwrite hashCode() function in Hashtable class
    public int hashCode(){
    //return stringHash(); //15 ms
      return base3Hash(); // 31 ms
    }
    
    // hashcode for string hash
    public int stringHash(){
    	return myBoard.toString().hashCode();
    }
    
    // hashcode for base 3 hash
    public int base3Hash(){
    	StringBuffer base3 = new StringBuffer("");
    	for(int i = 0; i < 8; i++){
    		switch(myBoard.charAt(i)){
    		case BLANK: base3.append('0');
    					break;
    		case 'X'  : base3.append('1');
    					break;
    		case 'O'  : base3.append('2');
    					break;
    		}
    	}
    	return base3.toString().hashCode();
    }
}
