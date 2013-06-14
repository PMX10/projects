import java.util.List;
import java.util.ArrayList;
import java.util.Hashtable;


// Graph class: evaluate shortest paths.
// Implementing Prim's algorithm
public class Graph
{
    protected Hashtable<String,Vertex> graphTable;
    
    public Graph(){
    	graphTable = new Hashtable<String, Vertex>();
    }
    
    
	public void addVertex(String vertexName){
    	Vertex newVertex = new Vertex(vertexName);
    	graphTable.put(vertexName, newVertex);
    }


    private Vertex getVertex(String name)
    {
        Vertex v = graphTable.get(name);
        return v;
    }


    public void addEdge(String sourceName, String destName, int cost)
    {
        Vertex v = getVertex(sourceName);
        Vertex w = getVertex(destName);
        v.getNeighbors().add(new Edge(w, cost));  //append the neighbor to the linkedlist
    }
    
    public void addDoubleEdge (String sourceName, String destName, int cost){
    	Vertex v = getVertex(sourceName);
    	Vertex w = getVertex(destName);
    	v.getNeighbors().add(new Edge(w, cost));
    	w.getNeighbors().add(new Edge(v, cost));
    }


	public void printGraph(){
		System.out.println("Graph contains " + graphTable.size() + " vertices.\n");
		for(Vertex v : graphTable.values()){
			//if(v.getNeighbors().isEmpty()){
				//System.out.println("No outwards edge in vertex.");
			//}
			for(Edge e : v.getNeighbors()){
				System.out.print("\"" + v + "\"");
				System.out.println("---\"" + e.getDestination() + "\" with cost: " + e.getCost());
			}
			System.out.println("---------------");
		}
	}
	
    public Graph primAlgorithm(String startingVertex){
    	
    	// first step is to check and see of the graph contains starting vertex
    	if(!graphTable.containsKey(startingVertex)){
    		System.out.println("No such starting vertex in graph.");
    		return null;
    	}

    	Graph resultGraph = new Graph();
    	resultGraph.addVertex(startingVertex);

    	// put the remaining vertices into a list
    	List<String> remainingVertexes = new ArrayList<String>();
    	for(Vertex v : graphTable.values()){
    		if(!v.getName().equals(startingVertex))
    			remainingVertexes.add(v.getName());
    	}
    	
    	Vertex sourceVertex = new Vertex();
		Vertex minVertex = new Vertex();;
		Edge minEdge = new Edge();
		int minCost;
    	
		// handling the remaining vertexes in the list
    	while(!remainingVertexes.isEmpty()){
			minCost = 999999;
    		// check all the vertexes in resultGraph
			for(Vertex v : resultGraph.graphTable.values()){
    			Vertex currentVetex = getVertex(v.getName());
    			
    			// check all the neighbors for every vertex
				for(Edge currentEdge : currentVetex.getNeighbors()){
					//find and store the minimum cost edge
    				if(currentEdge.getCost() < minCost)
    					//check and make sure there is not a loop
    					if (!resultGraph.graphTable.values().contains(currentEdge.getDestination())){
    						sourceVertex = currentVetex;
    						minVertex = currentEdge.getDestination();
    						minEdge = currentEdge;
    						minCost = currentEdge.getCost();
    				}
    			}
    		}
    		//add the vertex with shortest distance to resultGraph
			resultGraph.addVertex(minVertex.getName());
			
			//connect the two vertexes
    		resultGraph.addDoubleEdge(sourceVertex.getName(), minVertex.getName(), minEdge.getCost());
    		
    		//remove minVertex from the list
    		remainingVertexes.remove(minVertex.getName());
    	}
    	
    	return resultGraph;
    }

    public static void main( String [ ] args )
    {
    	Graph graph = new Graph();
    	graph.addVertex("1");
    	graph.addVertex("2");
    	graph.addVertex("3");
    	graph.addVertex("4");
    	graph.addVertex("5");
    	graph.addVertex("6");
    	graph.addDoubleEdge("1", "2", 1);
    	graph.addDoubleEdge("1", "3", 2);
    	graph.addDoubleEdge("2", "3", 1);
    	graph.addDoubleEdge("2", "4", 1);
    	graph.addDoubleEdge("3", "4", 2);
    	graph.addDoubleEdge("2", "5", 2);
    	graph.addDoubleEdge("4", "5", 2);
    	graph.addDoubleEdge("5", "6", 1);
    	graph.addDoubleEdge("4", "6", 1);
    	graph.addDoubleEdge("3", "6", 1);
    	System.out.println("Original Graph:");
    	graph.printGraph();
    	System.out.println();
    	for(int i = 1; i <= 6; i++){
    		System.out.println("Starting vertex : " + i);
    		graph.primAlgorithm(Integer.toString(i)).printGraph();
    		System.out.println();
    		System.out.println();
    	}
    }
    
}
