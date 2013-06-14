import java.util.LinkedList;
//import java.util.List;

//Represents a vertex in the graph.
public class Vertex
{
    private String name;   // Vertex name
    private LinkedList<Edge> neighbors;    // Adjacent vertices

    public Vertex(){ 
    	this.name = null; 
    	neighbors = new LinkedList<Edge>( );
    }
    
    public Vertex(String name){ 
    	this.name = name; 
    	neighbors = new LinkedList<Edge>( );
    }
    
    public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public LinkedList<Edge> getNeighbors() {
		return neighbors;
	}
	public void setNeighbors(LinkedList<Edge> neighbors) {
		this.neighbors = neighbors;
	}
	
	public String toString(){
		return name;
	}
	
	public int hashCode(){
		return name.hashCode();
	}
	
	public boolean equals(Object obj){
		return name.equals(((Vertex)obj).toString());
	}
}