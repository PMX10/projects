# qlearningAgents.py
# ------------------
# Licensing Information: Please do not distribute or publish solutions to this
# project. You are free to use and extend these projects for educational
# purposes. The Pacman AI projects were developed at UC Berkeley, primarily by
# John DeNero (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# For more info, see http://inst.eecs.berkeley.edu/~cs188/sp09/pacman.html

from game import *
from learningAgents import ReinforcementAgent
from featureExtractors import *

import random,util,math

class QLearningAgent(ReinforcementAgent):
  """
    Q-Learning Agent

    Functions you should fill in:
      - getQValue
      - getAction
      - getValue
      - getPolicy
      - update

    Instance variables you have access to
      - self.epsilon (exploration prob)
      - self.alpha (learning rate)
      - self.discount (discount rate)

    Functions you should use
      - self.getLegalActions(state)
        which returns legal actions
        for a state
  """
  def __init__(self, **args):
    "You can initialize Q-values here..."
    ReinforcementAgent.__init__(self, **args)

    "*** YOUR CODE HERE ***"
    self.q_values = util.Counter()
    self.actions = util.Counter()

  def getQValue(self, state, action):
    """
      Returns Q(state,action)
      Should return 0.0 if we never seen
      a state or (state,action) tuple
    """
    "*** YOUR CODE HERE ***"
    legal_actions = self.getLegalActions(state)
    if (state, action) not in self.q_values or len(legal_actions) == 0:
      return 0.0
    return self.q_values[(state,action)]


  def getValue(self, state):
    """
      Returns max_action Q(state,action)
      where the max is over legal actions.  Note that if
      there are no legal actions, which is the case at the
      terminal state, you should return a value of 0.0.
    """
    "*** YOUR CODE HERE ***"
    best_value = -9999
    legal_actions = self.getLegalActions(state)
    if len(legal_actions) == 0:
      return 0.0

    qvalues = []
    take_actions = []

    for action in legal_actions:
      qvalues.append(self.getQValue(state,action))
      take_actions.append(action)
    max_qvalue = max(qvalues)
    if qvalues.count(max_qvalue) == 1 and max_qvalue != 0:
      return_action = take_actions[qvalues.index(max_qvalue)]
    else:
      selection_list = []
      i = 0
      while i < len(qvalues):
        if qvalues[i] == max_qvalue:
          selection_list.append(i)
        i += 1
      return_action = take_actions[random.choice(selection_list)]
      #if max_qvalue == 0:
      #  max_qvalue = 0.5
    self.actions[state] = return_action

    return max_qvalue
    
    
    #for action in legal_actions:
    #  q_val = self.getQValue(state,action)
    #  if q_val > best_value:
    #    best_value = q_val
    #    self.actions[state] = action
    #return best_value

  def getPolicy(self, state):
    """
      Compute the best action to take in a state.  Note that if there
      are no legal actions, which is the case at the terminal state,
      you should return None.
    """
    "*** YOUR CODE HERE ***"
    legal_actions = self.getLegalActions(state)
    best_action = self.actions[state]
    if len(legal_actions) == 0:
      return None
    elif best_action in legal_actions: 
      return best_action
    else:
      return random.choice(legal_actions)
    #if len(legal_actions) != 0 and self.actions[state] in legal_actions:
    #  return self.actions[state]
    #else:
    #  return None
    

  def getAction(self, state):
    """
      Compute the action to take in the current state.  With
      probability self.epsilon, we should take a random action and
      take the best policy action otherwise.  Note that if there are
      no legal actions, which is the case at the terminal state, you
      should choose None as the action.

      HINT: You might want to use util.flipCoin(prob)
      HINT: To pick randomly from a list, use random.choice(list)
    """
    # Pick Action
    legalActions = self.getLegalActions(state)
    action = None
    "*** YOUR CODE HERE ***"
    best_action = self.actions[state]
    if len(legalActions) == 0:
      return None
    #if best_action == None:
    #  return None
    if util.flipCoin(self.epsilon) or best_action not in legalActions:
      action = random.choice(legalActions)
    else:
      action = self.getPolicy(state)
    return action

  def update(self, state, action, nextState, reward):
    """
      The parent class calls this to observe a
      state = action => nextState and reward transition.
      You should do your Q-Value update here

      NOTE: You should never call this function,
      it will be called on your behalf
    """
    "*** YOUR CODE HERE ***"
    self.q_values[(state, action)] = (1-self.alpha) * self.getQValue(state,action) + (self.alpha) * (reward + self.discount * self.getValue(nextState))

class PacmanQAgent(QLearningAgent):
  "Exactly the same as QLearningAgent, but with different default parameters"

  def __init__(self, epsilon=0.05,gamma=0.8,alpha=0.2, numTraining=0, **args):
    """
    These default parameters can be changed from the pacman.py command line.
    For example, to change the exploration rate, try:
        python pacman.py -p PacmanQLearningAgent -a epsilon=0.1

    alpha    - learning rate
    epsilon  - exploration rate
    gamma    - discount factor
    numTraining - number of training episodes, i.e. no learning after these many episodes
    """
    args['epsilon'] = epsilon
    args['gamma'] = gamma
    args['alpha'] = alpha
    args['numTraining'] = numTraining
    self.index = 0  # This is always Pacman
    QLearningAgent.__init__(self, **args)

  def getAction(self, state):
    """
    Simply calls the getAction method of QLearningAgent and then
    informs parent of action for Pacman.  Do not change or remove this
    method.
    """
    action = QLearningAgent.getAction(self,state)
    self.doAction(state,action)
    return action


class ApproximateQAgent(PacmanQAgent):
  """
     ApproximateQLearningAgent

     You should only have to overwrite getQValue
     and update.  All other QLearningAgent functions
     should work as is.
  """
  def __init__(self, extractor='IdentityExtractor', **args):
    self.featExtractor = util.lookup(extractor, globals())()
    PacmanQAgent.__init__(self, **args)

    # You might want to initialize weights here.
    "*** YOUR CODE HERE ***"
    self.weights = util.Counter() 

  def getQValue(self, state, action):
    """
      Should return Q(state,action) = w * featureVector
      where * is the dotProduct operator
    """
    "*** YOUR CODE HERE ***"
    q_value = 0
    features = self.featExtractor.getFeatures(state, action)
    for feat in features:
      q_value += self.weights[feat] * features[feat]
    return q_value

  def update(self, state, action, nextState, reward):
    """
       Should update your weights based on transition
    """
    "*** YOUR CODE HERE ***"
    features = self.featExtractor.getFeatures(state, action)
    for feat in features:
      self.weights[feat] = self.weights[feat] + self.alpha * (reward + self.discount*self.getValue(nextState) - self.getQValue(state, action)) * features[feat]

  def final(self, state):
    "Called at the end of each game."
    # call the super-class final method
    PacmanQAgent.final(self, state)

    # did we finish training?
    if self.episodesSoFar == self.numTraining:
      # you might want to print your weights here for debugging
      "*** YOUR CODE HERE ***"
      pass
