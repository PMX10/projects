
public class HeapNode {
	public int number;
	public HeapNode leftPtr;
	public HeapNode rightPtr;
	public HeapNode parentPtr;
	
	public HeapNode(int number) {
		this.number = number;
		leftPtr = null;
		rightPtr = null;
		parentPtr = null;
	}
	
	public String toString(){
		return Integer.toString(number);
	}
}
