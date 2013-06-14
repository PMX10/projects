
public class Block {
	private int length;
	private int width;
	private int row;
	private int col;
	private int id;
	private Tray parentTray;
	
	// Constructor
	public Block(int length, int width, int row, int col, int id, Tray parentTray){
		this.length = length;
		this.width = width;
		this.row = row;
		this.col = col;
		this.id = id;
		this.parentTray = parentTray;
	}
	
	// Copy Constructor for deep copy
	// Tray parentTray
	public Block(Block block, Tray parentTray){
		this.length = block.getLength();
		this.width = block.getWidth();
		this.row = block.getRow();
		this.col = block.getCol();
		this.id = block.getId();
		this.parentTray = parentTray;
	}
	
	public Tray getParentTray() {
		return parentTray;
		
	}

	public void setParentTray(Tray parentTray) {
		this.parentTray = parentTray;
	}

	//1: up 2:right 3:down 4:left
	public String move(int direction) {
		String moveInfo = null;       
		parentTray.removeTrayGrid(this);
		
		int beforeRow = this.row;
		int beforeCol = this.col;
		
		try{
			switch(direction) {
				case 1:	
					this.row--;
					break;
				case 2:
					this.col++;
					break;
				case 3:
					this.row++;
					break;
				case 4:
					this.col--;
			}
			parentTray.legalMove(this);
		}
		catch (IllegalStateException e){
			// if the state of the tray is illegal, change back to previous state
			switch(direction) {
				case 1:	
					this.row++;
					break;
				case 2:
					this.col--;
					break;
				case 3:
					this.row--;
					break;
				case 4:
					this.col++;
			}
			parentTray.updateTrayGrid(this);
			return moveInfo;
		}
		parentTray.updateTrayGrid(this);   //commit the move
		int afterRow = this.row;
		int afterCol = this.col;
		moveInfo = beforeRow + " " + beforeCol + " " + afterRow + " " + afterCol;
		return moveInfo;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getLength() {
		return length;
	}

	public void setLength(int length) {
		this.length = length;
	}

	public int getWidth() {
		return width;
	}

	public void setWidth(int width) {
		this.width = width;
	}
	
	public int getRow() {
		return row;
	}

	public void setRow(int row) {
		this.row = row;
	}

	public int getCol() {
		return col;
	}

	public void setCol(int col) {
		this.col = col;
	}

	// OUR DEBUGGING
	public String toString(){
		String str = new String();
		
		str += "X: " + Integer.toString(row) + "\n";
		str += "Y: " + Integer.toString(col) + "\n";
		
		return str;
	}
	
	// used for Hash Set
	public boolean equals(Object object) {
		Block block = (Block) object;
		return (block.getLength() == length && block.getWidth() == width && block.getRow() == row && block.getCol() == col);
	}	
}
