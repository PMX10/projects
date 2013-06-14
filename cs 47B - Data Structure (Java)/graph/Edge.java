// Represents an edge in the graph.
public class Edge
{
    private Vertex dest;   // Second vertex in Edge
    private int cost;   		  // Edge cost
    
    public Edge()
    {
        dest = null;
        cost = 0;
    }
    
    public Edge(Vertex d, int c)
    {
        dest = d;
        cost = c;
    }
    
    public Edge (Vertex d){
    	dest = d;
    	cost = 0;
    }

	public Vertex getDestination() {
		return dest;
	}
	public void setDestination(Vertex dest) {
		this.dest = dest;
	}
	public int getCost() {
		return cost;
	}
	public void setCost(int cost) {
		this.cost = cost;
	}
}