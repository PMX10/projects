import java.util.*;

public class AmoebaFamily {
	
	private Amoeba myHead = null;
	
	public AmoebaFamily (String name) {
		myHead = new Amoeba (name, null);
	}
	
	// Add a new amoeba named childName as the youngest child
	// of the amoeba named parentName.
	// Precondition: the amoeba family contains an amoeba named parentName.
	public void addChild (String parentName, String childName) {
		// You supply this code for exercise 1.
		addChild(myHead, parentName, childName);
	}		
	
	private void addChild(Amoeba newHead, String parentName, String childName){
		if (newHead.toString() == parentName){
			newHead.addChild(childName);
		}
		else{
			Enumeration<AmoebaFamily.Amoeba> v = newHead.myChildren.elements();
			while (v.hasMoreElements()){
				Amoeba nextChild = v.nextElement();
				addChild(nextChild, parentName, childName);
			}
		}
	}
	
	// Print the names of all amoebas in the family.
	// Names should appear in preorder, with children's names
	// printed oldest first.
	// Members of the family constructed with the main program above
	// should be printed in the following sequence:
	//		Amos McCoy, mom/dad, me, Mike, Bart, Lisa, Homer, Marge,
	//		Bill, Hilary, Fred, Wilma
	public void print ( ) {
		// You supply this code for exercise 2.
		print(myHead);
	}
	
	private void print(Amoeba newHead){
		if(newHead == null){
			System.out.println("Amoeba family has no member");
		}
		else{
			System.out.println(newHead);
			Enumeration<AmoebaFamily.Amoeba> v = newHead.myChildren.elements();
			while (v.hasMoreElements()){
				print(v.nextElement());
			}
		}
	}
	
	public static void main (String [ ] args) {
		AmoebaFamily family = new AmoebaFamily ("Amos McCoy");
		family.addChild ("Amos McCoy", "mom/dad");
		family.addChild ("mom/dad", "me");
		family.addChild ("mom/dad", "Fred");
		family.addChild ("mom/dad", "Wilma");
		family.addChild ("me", "Mike");
		family.addChild ("me", "Homer");
		family.addChild ("me", "Marge");
		family.addChild ("Mike", "Bart");
		family.addChild ("Mike", "Lisa");
		family.addChild ("Marge", "Bill");
		family.addChild ("Marge", "Hilary");
		System.out.println ("Here's the family:");
		family.print ( );
		System.out.println ("");
		System.out.println ("Here it is again!");
		AmoebaEnumeration iter = family.new AmoebaEnumeration ( );
		while (iter.hasMoreElements ( )) {
			System.out.println (((Amoeba) iter.nextElement ( )));
		}
	}
	//exercise 3: preorder in stack
	public class AmoebaEnumeration implements Enumeration {
		// Amoebas in the family are enumerated in preorder,
		// with children enumerated oldest first.
		// Members of the family constructed with the main program above
		// should be enumerated in the following sequence:
		//		Amos McCoy, mom/dad, me, Mike, Bart, Lisa, Homer, Marge,
		//		Bill, Hilary, Fred, Wilma
		// Complete enumeration of a family of N amoebas should take
		// O(N) operations.
		
		// You supply the details of this class for exercises 3 and 4.
		 
		private Stack amoebaStack = new Stack();
		
		public AmoebaEnumeration (){
			amoebaStack.push(myHead);
		}
		
		public boolean hasMoreElements() {
			return !amoebaStack.isEmpty();
		}
		
		public Object nextElement() {
			Amoeba temp = (Amoeba)amoebaStack.pop();
			int i = temp.myChildren.size()-1;
			while (!temp.myChildren.isEmpty() && i>=0){
				amoebaStack.push(temp.myChildren.elementAt(i--));
			}
			return temp;
		}
	}
	/*
	public class AmoebaEnumeration implements Enumeration {
		// Amoebas in the family are enumerated in preorder,
		// with children enumerated oldest first.
		// Members of the family constructed with the main program above
		// should be enumerated in the following sequence:
		//		Amos McCoy, mom/dad, me, Mike, Bart, Lisa, Homer, Marge,
		//		Bill, Hilary, Fred, Wilma
		// Complete enumeration of a family of N amoebas should take
		// O(N) operations.
		
		// You supply the details of this class for exercises 3 and 4.
		private Queue amoebaQueue = new LinkedList();
		
		public AmoebaEnumeration (){
			amoebaQueue.offer(myHead);
		}
		
		public boolean hasMoreElements() {
			return !amoebaQueue.isEmpty();
		}

		public Object nextElement() {
			Amoeba temp = (Amoeba)amoebaQueue.poll();
			Enumeration v = temp.myChildren.elements();
			while (v.hasMoreElements()){
				amoebaQueue.offer((Amoeba)v.nextElement());
			}
			return temp;
		}
	}
	*/
	private class Amoeba {

		public String myName;		// amoeba's name
		public Amoeba myParent;		// amoeba's parent
		public Vector myChildren;		// amoeba's children
		
		public Amoeba (String name, Amoeba parent) {
			myName = name;
			myParent = parent;
			myChildren = new Vector ( );
		}
		
		public String toString ( ) {
			return myName;
		}
		
		public Amoeba parent ( ) {
			return myParent;
		}
		

		// Add an amoeba with the given name as this amoeba's youngest child.
		public void addChild (String childName) {
			Amoeba child = new Amoeba (childName, this);
			myChildren.addElement (child);
		}
	}
}	// closes definition of AmoebaFamily class