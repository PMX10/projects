# search.py
# ---------
# Licensing Information: Please do not distribute or publish solutions to this
# project. You are free to use and extend these projects for educational
# purposes. The Pacman AI projects were developed at UC Berkeley, primarily by
# John DeNero (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# For more info, see http://inst.eecs.berkeley.edu/~cs188/sp09/pacman.html

"""
In search.py, you will implement generic search algorithms which are called
by Pacman agents (in searchAgents.py).
"""

import util

from util import Stack
from util import Queue
from util import PriorityQueue
from game import Directions

class Node:
    def __init__(self, state = None, direction = None, cost = 0, parentNode= None):
        self.state = state
        self.direction = direction
        self.cost = cost
        self.parentNode = parentNode


class SearchProblem:
    """
    This class outlines the structure of a search problem, but doesn't implement
    any of the methods (in object-oriented terminology: an abstract class).

    You do not need to change anything in this class, ever.
    """

    def getStartState(self):
        """
        Returns the start state for the search problem
        """
        util.raiseNotDefined()

    def isGoalState(self, state):
        """
          state: Search state

        Returns True if and only if the state is a valid goal state
        """
        util.raiseNotDefined()

    def getSuccessors(self, state):
        """
          state: Search state

        For a given state, this should return a list of triples,
        (successor, action, stepCost), where 'successor' is a
        successor to the current state, 'action' is the action
        required to get there, and 'stepCost' is the incremental
        cost of expanding to that successor
        """
        util.raiseNotDefined()

    def getCostOfActions(self, actions):
        """
         actions: A list of actions to take

        This method returns the total cost of a particular sequence of actions.  The sequence must
        be composed of legal moves
        """
        util.raiseNotDefined()


def tinyMazeSearch(problem):
    """
    Returns a sequence of moves that solves tinyMaze.  For any other
    maze, the sequence of moves will be incorrect, so only use this for tinyMaze
    """
    from game import Directions
    s = Directions.SOUTH
    w = Directions.WEST
    return  [s,s,w,s,w,w,s,w]

def search(problem, nodeList):

    node = Node(problem.getStartState(), Directions.STOP, 1, None)
    visited = {}
    path = []
    visited[node.state] = True
    nodeList.push(node)
    while nodeList:
        node = nodeList.pop()
        if problem.isGoalState(node.state):
            path.append(node.direction)
            while node.parentNode:
                path.insert(0,(node.parentNode.direction))
                node = node.parentNode
            return path[1:]
        for successorState in problem.getSuccessors(node.state):
            node2 = Node(successorState[0],successorState[1],successorState[2],node)
            if node2.state not in visited:
                visited[node2.state] = True
                nodeList.push(node2)
    return None

def depthFirstSearch(problem):
    """
    Search the deepest nodes in the search tree first
    [2nd Edition: p 75, 3rd Edition: p 87]

    Your search algorithm needs to return a list of actions that reaches
    the goal.  Make sure to implement a graph search algorithm
    [2nd Edition: Fig. 3.18, 3rd Edition: Fig 3.7].

    To get started, you might want to try some of these simple commands to
    understand the search problem that is being passed in:

    print "Start:", problem.getStartState()
    print "Is the start a goal?", problem.isGoalState(problem.getStartState())
    print "Start's successors:", problem.getSuccessors(problem.getStartState())
    """
    "*** YOUR CODE HERE ***"
    """
    print "Start:", problem.getStartState()
    print "Is the start a goal?", problem.isGoalState(problem.getStartState())
    print "Start's successors:", problem.getSuccessors(problem.getStartState())
    """
    #util.raiseNotDefined()
    return search(problem, Stack())

def breadthFirstSearch(problem):
    """
    Search the shallowest nodes in the search tree first.
    [2nd Edition: p 73, 3rd Edition: p 82]
    """
    "*** YOUR CODE HERE ***"
    #util.raiseNotDefined()
    return search(problem, Queue())

def uniformCostSearch(problem):
    "Search the node of least total cost first. "
    "*** YOUR CODE HERE ***"
    #util.raiseNotDefined()
    nodeList = PriorityQueue()
    node = Node(problem.getStartState(), Directions.STOP, 0, None)
    visited = {}
    path = []
    visited[node.state] = True
    nodeList.push(node,0) 
    while nodeList:
        node = nodeList.pop()
        visited[node.state] = True
        if problem.isGoalState(node.state):
            path.append(node.direction)
            while node.parentNode:
                path.insert(0,(node.parentNode.direction))
                node = node.parentNode
            return path[1:]
        
        for successorState in problem.getSuccessors(node.state):
            node2 = Node(successorState[0],successorState[1], node.cost + successorState[2],node)
            if node2.state not in visited:
                
                nodeList.push(node2,node2.cost)
    return None
    
def nullHeuristic(state, problem=None):
    """
    A heuristic function estimates the cost from the current state to the nearest
    goal in the provided SearchProblem.  This heuristic is trivial.
    """
    return 0

def aStarSearch(problem, heuristic=nullHeuristic):
    "Search the node that has the lowest combined cost and heuristic first."
    "*** YOUR CODE HERE ***"
    #util.raiseNotDefined()
    node = Node(problem.getStartState(),Directions.STOP,0) 

    nodeList = PriorityQueue()
    visited = {}
    path = []
    nodeList.push(node, 0)
    f = {}
    g = {}
    h = {}
    g[node.state] = 0
    h[node.state] = heuristic(node.state, problem)
    f[node.state] = g[node.state] + h[node.state]    
    while nodeList:
        node = nodeList.pop()
        if problem.isGoalState(node.state):
            path.insert(0,(node.direction))
            while node.parentNode:
                path.insert(0,(node.parentNode.direction))
                node = node.parentNode
            #print "path: ", path
            return path[1:]
        #visited[node.state] = True
        for successorState in problem.getSuccessors(node.state):
            node2 = Node(successorState[0],successorState[1],1,node)
            g[node2.state] = g[node.state] + successorState[2]
            h[node2.state] = heuristic(node2.state, problem)
            temp_f = g[node2.state] + h[node2.state]

            if node2.state not in visited:
                visited[node2.state] = True
                node2.cost = f[node2.state] = temp_f
                nodeList.push(node2, node2.cost)
            else:
                if temp_f < f[node2.state]:
                    node2.cost = f[node2.state] = temp_f
                    nodeList.push(node2, node2.cost)    
    return None

def updateCost(q, state, cost, parent):
    print state
    for node in q.heap:
        print node
        
        if node[0] == state and node[0] > cost:
            node[0].cost = cost
            node[0].parentNode = parent


def inQueue(q, state):
    if state in q.heap:
        return True
    return False
    


# Abbreviations
bfs = breadthFirstSearch
dfs = depthFirstSearch
astar = aStarSearch
ucs = uniformCostSearch
