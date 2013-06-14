# multiAgents.py
# --------------
# Licensing Information: Please do not distribute or publish solutions to this
# project. You are free to use and extend these projects for educational
# purposes. The Pacman AI projects were developed at UC Berkeley, primarily by
# John DeNero (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# For more info, see http://inst.eecs.berkeley.edu/~cs188/sp09/pacman.html

from util import manhattanDistance
from game import Directions
import random, util, time

from game import Agent

class ReflexAgent(Agent):
  """
    A reflex agent chooses an action at each choice point by examining
    its alternatives via a state evaluation function.

    The code below is provided as a guide.  You are welcome to change
    it in any way you see fit, so long as you don't touch our method
    headers.
  """


  def getAction(self, gameState):
    """
    You do not need to change this method, but you're welcome to.

    getAction chooses among the best options according to the evaluation function.

    Just like in the previous project, getAction takes a GameState and returns
    some Directions.X for some X in the set {North, South, West, East, Stop}
    """
    # Collect legal moves and successor states
    legalMoves = gameState.getLegalActions()

    # Choose one of the best actions
    scores = [self.evaluationFunction(gameState, action) for action in legalMoves]
    bestScore = max(scores)
    bestIndices = [index for index in range(len(scores)) if scores[index] == bestScore]
    chosenIndex = random.choice(bestIndices) # Pick randomly among the best

    "Add more of your code here if you want to"

    return legalMoves[chosenIndex]

  def evaluationFunction(self, currentGameState, action):
    """
    Design a better evaluation function here.

    The evaluation function takes in the current and proposed successor
    GameStates (pacman.py) and returns a number, where higher numbers are better.

    The code below extracts some useful information from the state, like the
    remaining food (newFood) and Pacman position after moving (newPos).
    newScaredTimes holds the number of moves that each ghost will remain
    scared because of Pacman having eaten a power pellet.

    Print out these variables to see what you're getting, then combine them
    to create a masterful evaluation function.
    """
    # Useful information you can extract from a GameState (pacman.py)
    successorGameState = currentGameState.generatePacmanSuccessor(action)
    newPos = successorGameState.getPacmanPosition()
    newFood = successorGameState.getFood()
    newGhostStates = successorGameState.getGhostStates()
    newScaredTimes = [ghostState.scaredTimer for ghostState in newGhostStates]

    "*** YOUR CODE HERE ***"
    #return successorGameState.getScore()

    ghostScore = 0
    foodDistance = []
    minFoodDistance = 10000000
    for food in newFood.asList():
        foodDistance.append(manhattanDistance(food, newPos))
    if len(foodDistance)>=1:
      minFoodDistance = min(foodDistance)
    foodScore = 1.0/(100+minFoodDistance)
    foodScore += 5.0/(len(newFood.asList())+1)
    
    for ghost in newGhostStates:
        dist = manhattanDistance(newPos, ghost.getPosition())
        if dist <= 1 and ghost.scaredTimer <= 0:
          return -100000000000
        elif dist < 3 and ghost.scaredTimer > 0:
          ghostScore += 1000000

    return foodScore + ghostScore

def scoreEvaluationFunction(currentGameState):
  """
    This default evaluation function just returns the score of the state.
    The score is the same one displayed in the Pacman GUI.

    This evaluation function is meant for use with adversarial search agents
    (not reflex agents).
  """
  return currentGameState.getScore()

class MultiAgentSearchAgent(Agent):
  """
    This class provides some common elements to all of your
    multi-agent searchers.  Any methods defined here will be available
    to the MinimaxPacmanAgent, AlphaBetaPacmanAgent & ExpectimaxPacmanAgent.

    You *do not* need to make any changes here, but you can if you want to
    add functionality to all your adversarial search agents.  Please do not
    remove anything, however.

    Note: this is an abstract class: one that should not be instantiated.  It's
    only partially specified, and designed to be extended.  Agent (game.py)
    is another abstract class.
  """

  def __init__(self, evalFn = 'scoreEvaluationFunction', depth = '2'):
    self.index = 0 # Pacman is always agent index 0
    self.evaluationFunction = util.lookup(evalFn, globals())
    self.depth = int(depth)

class MinimaxAgent(MultiAgentSearchAgent):
  """
    Your minimax agent (question 2)
  """

  def getAction(self, gameState):
    """
      Returns the minimax action from the current gameState using self.depth
      and self.evaluationFunction.

      Here are some method calls that might be useful when implementing minimax.

      gameState.getLegalActions(agentIndex):
        Returns a list of legal actions for an agent
        agentIndex=0 means Pacman, ghosts are >= 1

      Directions.STOP:
        The stop direction, which is always legal

      gameState.generateSuccessor(agentIndex, action):
        Returns the successor game state after an agent takes an action

      gameState.getNumAgents():
        Returns the total number of agents in the game
    """
    "*** YOUR CODE HERE ***"
    #util.raiseNotDefined()
    value = -999999999
    returnAction = Directions.STOP
    for action in gameState.getLegalActions(0):
        temp = self.minValue(0, 1, gameState.generateSuccessor(0, action))
        if temp > value:
          value = temp
          returnAction = action
 
    return returnAction
               
 
  def maxValue(self, depth, agent, state):
    if depth == self.depth or state.isLose() or state.isWin():
      return self.evaluationFunction(state)

    value = -999999999
    for action in state.getLegalActions(agent):
      temp = self.minValue(depth, agent+1, state.generateSuccessor(agent, action))
      if temp > value:
        value = temp
    return value
 
  def minValue(self, depth, agent, state):
    if depth == self.depth or state.isLose() or state.isWin():
      return self.evaluationFunction(state)

    value = 999999999
    for action in state.getLegalActions(agent):
      if agent != state.getNumAgents() - 1:    #other ghosts
        temp = self.minValue(depth, agent+1, state.generateSuccessor(agent, action))
      else:   #pacman
        temp = self.maxValue(depth+1, 0, state.generateSuccessor(agent, action))

        if temp < value:
          value = temp
    return value

class AlphaBetaAgent(MultiAgentSearchAgent):
  """
    Your minimax agent with alpha-beta pruning (question 3)
  """

  def getAction(self, gameState):
    """
      Returns the minimax action using self.depth and self.evaluationFunction
    """
    "*** YOUR CODE HERE ***"
    #util.raiseNotDefined()
    value = -999999999
    returnAction = Directions.STOP
    for action in gameState.getLegalActions(0):
        print value, value*-1
        temp = self.minValue(0, 1, gameState.generateSuccessor(0, action), value, value*-1)
        if temp > value:
          value = temp
          returnAction = action
 
    return returnAction
               
 
  def maxValue(self, depth, agent, state, alpha, beta):
    if depth == self.depth or state.isLose() or state.isWin():
      return self.evaluationFunction(state)

    value = -999999999
    for action in state.getLegalActions(agent):
      value = max(value, self.minValue(depth+1, agent+1, state.generateSuccessor(agent, action),alpha, beta))
      if value >= beta: return value
      alpha = max(alpha,value)
    return value
 
  def minValue(self, depth, agent, state, alpha, beta):
    if depth == self.depth or state.isLose() or state.isWin():
      return self.evaluationFunction(state)

    value = 999999999
    for action in state.getLegalActions(agent):
      if agent != state.getNumAgents() - 1:    #other ghosts
        value = min(value,self.minValue(depth, agent+1, state.generateSuccessor(agent, action), alpha, beta))
      else:   #pacman
        value = min(value,self.maxValue(depth+1, 0, state.generateSuccessor(agent, action), alpha, beta))

      if value <= alpha: return value
      beta = min(beta, value)
    return value


class ExpectimaxAgent(MultiAgentSearchAgent):
  """
    Your expectimax agent (question 4)
  """

  def getAction(self, gameState):
    """
      Returns the expectimax action using self.depth and self.evaluationFunction

      All ghosts should be modeled as choosing uniformly at random from their
      legal moves.
    """
    "*** YOUR CODE HERE ***"
    #util.raiseNotDefined()
    value = -999999999
    returnAction = Directions.STOP
    for action in gameState.getLegalActions(0):
        temp = self.expectedValue(0, 1, gameState.generateSuccessor(0, action))
        if temp > value:
          value = temp
          returnAction = action
 
    return returnAction
               
 
  def maxValue(self, depth, agent, state):
    if depth == self.depth or state.isLose() or state.isWin():
      return self.evaluationFunction(state)

    value = -999999999
    for action in state.getLegalActions(agent):
      temp = self.expectedValue(depth, agent+1, state.generateSuccessor(agent, action))
      if temp > value:
        value = temp
    return value
 
  def expectedValue(self, depth, agent, state):
    if depth == self.depth or state.isLose() or state.isWin():
      return self.evaluationFunction(state)

    value = 0
    for action in state.getLegalActions(agent):
      if agent != state.getNumAgents() - 1:    #other ghosts
        value += self.expectedValue(depth, agent+1, state.generateSuccessor(agent, action))
      else:   #pacman
        value += self.maxValue(depth+1, 0, state.generateSuccessor(agent, action))

    return value/len(state.getLegalActions(agent))

def betterEvaluationFunction(currentGameState):
  """
    Your extreme ghost-hunting, pellet-nabbing, food-gobbling, unstoppable
    evaluation function (question 5).

    DESCRIPTION: <write something here so we know what you did>
  """
  "*** YOUR CODE HERE ***"
  #util.raiseNotDefined()
  #successorGameState = currentGameState.generatePacmanSuccessor(action)
  newPos = currentGameState.getPacmanPosition()
  newFood = currentGameState.getFood()
  newGhostStates = currentGameState.getGhostStates()
  #newScaredTimes = [ghostState.scaredTimer for ghostState in newGhostStates]

  ghostScore = 0
  foodDistance = []
  minFoodDistance = 10000000
  for food in newFood.asList():
      foodDistance.append(manhattanDistance(food, newPos))
  if len(foodDistance)>=1:
    minFoodDistance = min(foodDistance)
  foodScore = 1.0/(100+minFoodDistance)
  foodScore += 5.0/(len(newFood.asList())+1)
   
  for ghost in newGhostStates:
      dist = manhattanDistance(newPos, ghost.getPosition())
      if dist <= 1 and ghost.scaredTimer <= 0:
        return -100000000000
      elif dist < 3 and ghost.scaredTimer > 0:
        ghostScore += 1000000
  return foodScore + ghostScore


# Abbreviation
better = betterEvaluationFunction

class ContestAgent(MultiAgentSearchAgent):
  """
    Your agent for the mini-contest
  """

  def getAction(self, gameState):
    """
      Returns an action.  You can use any method you want and search to any depth you want.
      Just remember that the mini-contest is timed, so you have to trade off speed and computation.

      Ghosts don't behave randomly anymore, but they aren't perfect either -- they'll usually
      just make a beeline straight towards Pacman (or away from him if they're scared!)
    """
    "*** YOUR CODE HERE ***"
    util.raiseNotDefined()

