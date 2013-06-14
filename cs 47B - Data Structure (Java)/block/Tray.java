import java.util.*;
import java.io.*;

public class Tray {
	
	
	private HashSet<String> hashset;  //checks for duplicate states
	
	public int rows;
	public int cols;
	public ArrayList<Block> blockList;
	public int[][] trayGrid;  // grid representing tray
	public String solution;
	private boolean debug = false;
	
	
	private Scanner openFile(String filename){
		try {
			Scanner reader = new Scanner(new FileReader(filename));
			return reader;
		}
		catch (FileNotFoundException e){
			e.printStackTrace();
		}
		return null;
	}
	
	public Tray(String filename, int numrows, int numcols) {
		blockList = new ArrayList<Block>();
		hashset = new HashSet<String>();
		solution = new String();
		
		Scanner configFile = openFile(filename);
		
		String tempLine;
		tempLine = configFile.nextLine();
		StringTokenizer st = new StringTokenizer(tempLine);
		if(numrows == -1){
			this.rows = Integer.parseInt(st.nextToken());
			this.cols = Integer.parseInt(st.nextToken());
		}
		else {
			this.rows = numrows;
			this.cols = numcols;
		}
		
		trayGrid = new int[this.rows][this.cols];
		for (int i = 0; i < rows; i++) {
			for (int j = 0; j < cols; j++){
				trayGrid[i][j] = -1;
			}
		}
		
		
		while(configFile.hasNextLine()){
			tempLine = configFile.nextLine();
			st = new StringTokenizer(tempLine);
			
			int tempLength = Integer.parseInt(st.nextToken());
			int tempWidth = Integer.parseInt(st.nextToken());
			int tempRow = Integer.parseInt(st.nextToken());
			int tempCol = Integer.parseInt(st.nextToken());
			
			Block tempBlock = new Block(tempLength, tempWidth, tempRow, tempCol,
										blockList.size(),
										this);
			
			legalMove(tempBlock);
			updateTrayGrid(tempBlock);
			blockList.add(tempBlock);
		}
		
		int blankCount = 0;
		for(int i = 0; i < this.rows; i++) {
			for(int j = 0; j < this.cols; j++) {
				if(trayGrid[i][j] == -1)
					blankCount++;
			}
		}
	}

	public String getSolution() {
		return solution;
	}

	public void setSolution(String solution) {
		this.solution = solution;
	}

	public Tray(Tray tray){
		this.rows = tray.getRows();
		this.cols = tray.getCols();
		this.trayGrid = new int[this.rows][this.cols];
		for (int i = 0; i < rows; i++) {
			for (int j = 0; j < cols; j++){
				trayGrid[i][j] = -1;
			}
		}
		this.blockList = new ArrayList<Block>();
		for(Block block : tray.getBlockList()){
			this.blockList.add(new Block(block, this));
			this.updateTrayGrid(block);
		}
		this.solution = new String(tray.getSolution());
	}

	public int getRows() {
		return rows;
	}
	
	public void setRows(int rows) {
		this.rows = rows;
	}

	public int getCols() {
		return cols;
	}

	public void setCols(int cols) {
		this.cols = cols;
	}

	public ArrayList<Block> getBlockList() {
		return blockList;
	}

	public void setBlockList(ArrayList<Block> blockList) {
		this.blockList = blockList;
	}

	public int[][] getTrayGrid() {
		return trayGrid;
	}

	public void setTrayGrid(int[][] trayGrid) {
		this.trayGrid = trayGrid;
	}

	void legalMove(Block newBlock) throws IllegalStateException {

		for (int i = newBlock.getRow(); i < newBlock.getRow() + newBlock.getLength(); i++) {
			for (int j = newBlock.getCol(); j < newBlock.getCol() + newBlock.getWidth(); j++){
				try{
					if (trayGrid[i][j] != -1)
						throw new IllegalStateException("Trying to add on occupied space. ");
				}
				catch(ArrayIndexOutOfBoundsException e){
					throw new IllegalStateException("Array index out of bounds. ");
				}
			}
		}
		return;
	}
	
	void updateTrayGrid(Block newBlock) {
		for (int i = newBlock.getRow(); i < newBlock.getRow() + newBlock.getLength(); i++) 
			for (int j = newBlock.getCol(); j < newBlock.getCol() + newBlock.getWidth(); j++)
				trayGrid[i][j] = newBlock.getId();
		return;
	}
	
	void removeTrayGrid(Block block) {
		for (int i = block.getRow(); i < block.getRow() + block.getLength(); i++) 
			for (int j = block.getCol(); j < block.getCol() + block.getWidth(); j++)
				trayGrid[i][j] = -1;
		return;
	}
/*
	public ArrayList<Tray> generateMoves() {
		ArrayList<Tray> moveArray = new ArrayList<Tray>();
		
		for(int i = 0; i < blockList.size(); i++) {
			for(int j = 1; j < 5; j++) { // 1: up 2:right 3:down 4:left
				Tray nextTray = new Tray(this);
				String moveInfo = nextTray.getBlockList().get(i).move(j);
				if(moveInfo != null) {
					moveArray.add(nextTray);
					if (debug)
						nextTray.debugPrint();
					nextTray.setSolution(nextTray.getSolution() + moveInfo + '\n');
				}
			}
		}
		return moveArray;
	}
*/
	public ArrayList<Tray> generateMoves(){
		ArrayList<Tray> newMoves = new ArrayList<Tray>();
		int temp;
		
		for(int i = 0; i < this.rows; i++) {
			for(int j = 0; j < this.cols; j++) {
				// If it's a blank spot:
				if(trayGrid[i][j] == -1) {
//					System.out.println(i + " " + j);
					try {
						temp = trayGrid[i - 1][j];
//						System.out.println("TRY DOWN");
						if(temp != -1){
							Tray nextTray = new Tray(this);
							String moveInfo = nextTray.getBlockList().get(temp).move(3);
							if(moveInfo != null) {
								newMoves.add(nextTray);
								//if (debug)
									//nextTray.debugPrint();
								//out.println(nextTray.toString());
								
								/*
								out.write("Rows: " + Integer.toString(nextTray.rows));
								out.println();
								out.write("Columns: " + Integer.toString(nextTray.cols));
								out.println();
		
								for(int a = 0; a < nextTray.rows; a++){
									for(int b = 0; b < nextTray.cols; b++){
										out.write(Integer.toString(nextTray.trayGrid[a][b]) + " ");
									}
									out.println();
								}		
								out.println();
								*/
								nextTray.setSolution(nextTray.getSolution() + moveInfo + '\n');
							}
						}
					}
					catch(ArrayIndexOutOfBoundsException e) {
//						System.out.println("DOWN");
					}
					try {
						temp = trayGrid[i + 1][j];
//						System.out.println("TRY UP");
						if(temp != -1){
							Tray nextTray = new Tray(this);
							String moveInfo = nextTray.getBlockList().get(temp).move(1);
							if(moveInfo != null) {
								newMoves.add(nextTray);
								//if (debug)
									//nextTray.debugPrint();
									//out.println(nextTray.toString());
								/*
								out.write("Rows: " + Integer.toString(nextTray.rows));
								out.println();
								out.write("Columns: " + Integer.toString(nextTray.cols));
								out.println();
		
								for(int a = 0; a < nextTray.rows; a++){
									for(int b = 0; b < nextTray.cols; b++){
										out.write(Integer.toString(nextTray.trayGrid[a][b]) + " ");
									}
									out.println();
								}		
								out.println();
								*/
								
								nextTray.setSolution(nextTray.getSolution() + moveInfo + '\n');
							}
						}
					}
					catch(ArrayIndexOutOfBoundsException e) {	
//						System.out.println("UP");
					}
					try {
						temp = trayGrid[i][j + 1];
//						System.out.println("TRY LEFT");
						if(temp != -1){
							Tray nextTray = new Tray(this);
							String moveInfo = nextTray.getBlockList().get(temp).move(4);
							if(moveInfo != null) {
								newMoves.add(nextTray);
								//if (debug)
									//nextTray.debugPrint();
									//out.println(nextTray.toString());
								/*
								out.write("Rows: " + Integer.toString(nextTray.rows));
								out.println();
								out.write("Columns: " + Integer.toString(nextTray.cols));
								out.println();
		
								for(int a = 0; a < nextTray.rows; a++){
									for(int b = 0; b < nextTray.cols; b++){
										out.write(Integer.toString(nextTray.trayGrid[a][b]) + " ");
									}
									out.println();
								}		
								out.println();
								*/
								nextTray.setSolution(nextTray.getSolution() + moveInfo + '\n');
							}
						}
					}
					catch(ArrayIndexOutOfBoundsException e) {
//						System.out.println("LEFT");
					}
					try {
						temp = trayGrid[i][j - 1];
//						System.out.println("TRY RIGHT");
						if(temp != -1){
							Tray nextTray = new Tray(this);
							String moveInfo = nextTray.getBlockList().get(temp).move(2);
							if(moveInfo != null) {
								newMoves.add(nextTray);
								//if (debug)
									//nextTray.debugPrint();
									//out.println(nextTray.toString());
								/*	
								out.write("Rows: " + Integer.toString(nextTray.rows));
								out.println();
								out.write("Columns: " + Integer.toString(nextTray.cols));
								out.println();
		
								for(int a = 0; a < nextTray.rows; a++){
									for(int b = 0; b < nextTray.cols; b++){
										out.write(Integer.toString(nextTray.trayGrid[a][b]) + " ");
									}
									out.println();
								}		
								out.println();
								
								*/
								nextTray.setSolution(nextTray.getSolution() + moveInfo + '\n');
							}
						}
					}
					catch(ArrayIndexOutOfBoundsException e) {
//						System.out.println("RIGHT");
					}
				}
			}
		}
//		System.out.println(newMoves.size());
		return newMoves;
	}

	public boolean checkGoal(Tray targetTray){
		ArrayList<Block> targetBlockList = targetTray.getBlockList();
		
		for(Block targetBlock: targetBlockList){
			int index = trayGrid[targetBlock.getRow()][targetBlock.getCol()];
			if (index == -1 || !blockList.get(index).equals(targetBlock)) {
				return false;
			}
		}
		
		return true;
	}
	
	public void solve(Tray targetTray) {
		Queue<Tray> moveQueue = new LinkedList<Tray>();
	
		moveQueue.addAll(generateMoves());
		
		while(!moveQueue.isEmpty()) {
			Tray currentTray = moveQueue.poll();
			//currentTray.debugPrint();
			if(currentTray.checkGoal(targetTray)) {
				System.out.println("\nSolved!" + "\n");
				//out.write("\nSolved!" + "\n");
				//out.close();
				return;
				//System.exit(1);	
			}
			
			if(hashset.contains(currentTray.hashString())) {
				continue;
			}
			
			hashset.add(currentTray.hashString());
			
			for(Tray checkTray: currentTray.generateMoves()) {
				if(!hashset.contains(checkTray.hashString()))
					moveQueue.offer(checkTray);
			}
		}
		System.out.println("Not able to solve!");
	}
	
	public String toString(){
		String str = new String();
		
		str += "Rows: " + Integer.toString(rows) + "\n";
		str += "Columns: " + Integer.toString(cols) + "\n\n";
		
		for(int i = 0; i < rows; i++){
			for(int j = 0; j < cols; j++){
				str += Integer.toString(trayGrid[i][j]) + " ";
			}
			str += "\n";
		}
		
		return str;
	}
	
	public String hashString(){
		String hashStr = "";
		
		for(int i = 0; i < rows; i++) {
			for(int j = 0; j < cols; j++) {
				if(trayGrid[i][j] != -1)
					hashStr += Integer.toString(blockList.get(trayGrid[i][j]).getLength() + blockList.get(trayGrid[i][j]).getWidth()) + " ";
				else
					hashStr += "-1 ";
			}
			hashStr += ".";
		}
		return hashStr;
	}
	
	public void debugPrint(){
		System.out.println(this.toString());
		/*
		out.println("Rows: " + Integer.toString(rows));
		out.println("Columns: " + Integer.toString(cols));
		out.println();
		
		for(int i = 0; i < rows; i++){
			for(int j = 0; j < cols; j++){
				out.print(Integer.toString(trayGrid[i][j]) + " ");
			}
			out.println();
		}*/
	}
	
	
	
}
