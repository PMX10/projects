import java.util.*;

public class Heap {

	private HeapNode headNode;
	private int nodeCount;
	private int depth;
	private HeapNode lastNode;
	
	public Heap(){
		headNode = null;
		lastNode = null;
		nodeCount = 0;
		depth = 0;
	}
	
	// Evaluates to true if nodeCount is 0, which means heap is empty.
	public boolean isEmpty(){
		return nodeCount == 0;
	}


	public int top() throws NoSuchElementException {
		if(headNode == null){
			throw new NoSuchElementException("Trying to access empty heap.");
		}
		return headNode.number;
	}
	
	// Swaps the number in two headNodes.
	private void swap(HeapNode first, HeapNode second){
		int temp = first.number;
		first.number = second.number;
		second.number = temp;
	}

	private void reheapUp(HeapNode justInserted){
		if(justInserted != null && justInserted.parentPtr != null){
			if(justInserted.number > justInserted.parentPtr.number) {
				swap(justInserted, justInserted.parentPtr);
				reheapUp(justInserted.parentPtr);
			}
		}
		return;
	}
	
	public void add(int newNumber){
		System.out.println("Inserting " + newNumber);
		HeapNode newNode = new HeapNode(newNumber);
		
		// First time inserting an element. Just assign newNode to headNode.
		if (lastNode == null){
			headNode = newNode;
			depth++;
		}
		
		// If nodeCount is powers of two, then new level has to be created.
		// Find lowest, leftmost node and insert to left of this node.
		// O(log n) operation.
		else if(Math.pow(2,depth) - 1 == nodeCount){
			lastNode = headNode;
			
			while(lastNode.leftPtr != null){
				lastNode = lastNode.leftPtr;
			}
			newNode.parentPtr = lastNode;
			lastNode.leftPtr = newNode;
			depth++;
		}
		// If nodeCount is even, insert newNode to the right of just inserted node.
		else if (nodeCount % 2 == 0){
			newNode.parentPtr = lastNode.parentPtr;
			lastNode.parentPtr.rightPtr = newNode;
		}
		
		// If nodeCount is odd
		else if (nodeCount % 2 == 1){
			newNode.parentPtr = lastNode.parentPtr.parentPtr.rightPtr;
			lastNode.parentPtr.parentPtr.rightPtr.leftPtr = newNode;
		}
		// Keep updating justInsertedNode.
		lastNode = newNode;
		nodeCount++;
		
		reheapUp(lastNode);
		System.out.println("Done with inserting " + newNumber);
	}
	
	// Returns negative if left is larger than right, and positive
	// if right is larger than left.
	private int compareInt(HeapNode left, HeapNode right){
		return right.number - left.number;
	}
	
	private void reheapDown(HeapNode headNode){
		if(headNode != null){
			HeapNode greaterChild;
			
			if(headNode.leftPtr != null && headNode.rightPtr != null){
				if (compareInt(headNode.leftPtr, headNode.rightPtr) > 0)
					greaterChild = headNode.rightPtr;
				else
					greaterChild = headNode.leftPtr;
			}
			else if (headNode.leftPtr != null && headNode.rightPtr == null) {
				greaterChild = headNode.leftPtr;
			}
			else
				return;
			
			if (headNode.number < greaterChild.number){
				swap(headNode, greaterChild);
				reheapDown(greaterChild);
			}
		}
		return;
	}
	
	// Remove is basically the reverse of add. 
	public void remove() throws NoSuchElementException {
		if(isEmpty()){
			throw new NoSuchElementException("Trying to remove from empty heap.");
		}
		
		swap(lastNode, headNode);
		
		if (nodeCount == 1){
			headNode = null;
			lastNode = null;
		}
		// If the nodeCount is powers of 2, then have to move up one level.
		else if(Math.pow(2, depth-1) == nodeCount){
			lastNode.parentPtr.leftPtr = null;
			lastNode.parentPtr = null;
			lastNode = headNode;
			while(lastNode.rightPtr != null){
				lastNode = lastNode.rightPtr;
			}
			depth--;
		}
		else if (nodeCount % 2 == 1){
			HeapNode tempParent = lastNode.parentPtr;
			
			tempParent.rightPtr = null;
			lastNode.parentPtr = null;
			
			lastNode = tempParent.leftPtr;	
		}
		else if (nodeCount % 2 == 0){
			HeapNode tempParent = lastNode.parentPtr;
			
			tempParent.leftPtr = null;
			lastNode.parentPtr = null;
			
			lastNode = tempParent.parentPtr.leftPtr.rightPtr;
		}
		reheapDown(headNode);
		nodeCount--;
		System.out.println("Element removed.");
	}
	
	public static void main(String [] args){
		Heap heap = new Heap();
		heap.add(11);
		heap.add(12);
		heap.add(13);
		heap.add(14);
		heap.add(15);
		heap.add(16);
		heap.add(17);
		heap.printBreadthOrder();
		while(true){
			try{
				heap.remove();
				heap.printBreadthOrder();
			}
			catch (NoSuchElementException e){
				break;
			}
		}
//		heap.checkHeap();
		if(heap.isEmpty())
			System.out.println("Heap is empty and successfully unloaded.");
		
	}
	
	public void checkHeap(){
		checkHeap(headNode);
	}
	
	private void checkHeap(HeapNode head){
		if(head != null){
			if(head.leftPtr != null)
				assert head.number > head.leftPtr.number: "Checking left child of " + head.number;
			if(head.rightPtr != null)
				assert head.number > head.rightPtr.number: "Checking right child of " + head.number;
			checkHeap(head.leftPtr);
			checkHeap(head.rightPtr);
		}
		return;
	}
	
	private void printBreadthOrder(){
		HeapNode ptr = headNode;
		Queue<HeapNode> queue = new LinkedList<HeapNode>();
		while (ptr != null) {
			System.out.print(ptr + " ");
			if(ptr.leftPtr != null){
				queue.offer(ptr.leftPtr);
			}
			if(ptr.rightPtr != null){
				queue.offer(ptr.rightPtr);
			}
			if (!queue.isEmpty()){
				ptr = (HeapNode) queue.poll();
			} else {
				ptr = null;
			}
		}
		System.out.println();
		return;
	}
	
	
	public void printInOrder(){
		printInOrder(headNode);
	}
	
	private void printInOrder(HeapNode head){
		if(head != null){
			System.out.println(head);
			printInOrder(head.leftPtr);
			printInOrder(head.rightPtr);
		}
	}

}