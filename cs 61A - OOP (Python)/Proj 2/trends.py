"""
Zhaohua Gao    Login: cs61a-kk
Pei Jun Chen   Login: cs61a-kh
CS 61A project 2
"""



"""Visualizing Twitter Sentiment Across America"""

import string
from data import word_sentiments, load_tweets
from geo import us_states, geo_distance, make_position, longitude, latitude
from maps import draw_state, draw_name, draw_dot, wait
from ucb import main, trace, interact, log_current_line


# Phase 1: The feelings in tweets

def make_tweet(text, time, lat, lon):
    """Return a tweet, represented as a python dictionary.    

    text -- A string; the text of the tweet, all in lowercase
    time -- A datetime object; the time that the tweet was posted
    lat -- A number; the latitude of the tweet's location
    lon -- A number; the longitude of the tweet's location
    """
    return {'text': text, 'time': time, 'latitude': lat, 'longitude': lon}

def tweet_words(tweet):
    """Return a list of words in the tweet.
    
    Arguments:
    tweet -- a tweet abstract data type.
    
    Return 1 value:
     - The list of words in the tweet.
    """
    "*** YOUR CODE HERE ***"
    return extract_words(tweet['text'])

def tweet_location(tweet):
    """Return a position (see geo.py) that represents the tweet's location."""
    "*** YOUR CODE HERE ***"
    return make_position(tweet['latitude'], tweet['longitude'])

def tweet_string(tweet):
    """Return a string representing the tweet."""
    return '"{0}" @ {1}'.format(tweet['text'], tweet_location(tweet))

import re
def extract_words(text):
    """Return the words in a tweet, not including punctuation.

    >>> extract_words('anything else.....not my job')
    ['anything', 'else', 'not', 'my', 'job']
    >>> extract_words('i love my job. #winning')
    ['i', 'love', 'my', 'job', 'winning']
    >>> extract_words('make justin # 1 by tweeting #vma #justinbieber :)')
    ['make', 'justin', 'by', 'tweeting', 'vma', 'justinbieber']
    >>> extract_words("paperclips! they're so awesome, cool, & useful!")
    ['paperclips', 'they', 're', 'so', 'awesome', 'cool', 'useful']
    """
    "*** YOUR CODE HERE ***"
    regex = re.compile('[%s]' % re.escape(string.punctuation)).sub('', text)
    regex = re.sub(" \d+", " ", regex)
    return regex.split()

def get_word_sentiment(word):
    """Return a number between -1 and +1 representing the degree of positive or
    negative feeling in the given word. 

    Return None if the word is not in the sentiment dictionary.
    (0 represents a neutral feeling, not an unknown feeling.)
    
    >>> get_word_sentiment('good')
    0.875
    >>> get_word_sentiment('bad')
    -0.625
    >>> get_word_sentiment('winning')
    0.5
    >>> get_word_sentiment('Berkeley')  # Returns None
    """
    return word_sentiments.get(word, None)

def analyze_tweet_sentiment(tweet):
    """ Return a number between -1 and +1 representing the degree of positive or
    negative sentiment in the given tweet, averaging over all the words in the
    tweet that have a sentiment score. 

    If there are words that don't have a sentiment score, leave them 
    out of the calculation. 

    If no words in the tweet have a sentiment score, return None.
    (do not return 0, which represents neutral sentiment).

    >>> positive = make_tweet('i love my job. #winning', None, 0, 0)
    >>> round(analyze_tweet_sentiment(positive), 5)
    0.29167
    >>> negative = make_tweet("Thinking, 'I hate my job'", None, 0, 0)
    >>> analyze_tweet_sentiment(negative)
    -0.25
    >>> no_sentiment = make_tweet("Go bears!", None, 0, 0)
    >>> analyze_tweet_sentiment(no_sentiment)
    """
    average = None
    "*** YOUR CODE HERE ***"
    i, count, total = 0, 0, 0
    str = extract_words(tweet['text'])
    while i < len(str):
        if get_word_sentiment(str[i]) != None:
            count += 1
            total += get_word_sentiment(str[i])
        if count > 0:
            average = total/count
        i += 1
    return average

@main
def print_sentiment(text='Are you virtuous or verminous?'):
    """Print the words in text, annotated by their sentiment scores.

    For example, to print each word of a sentence with its sentiment:

    # python3 trends.py "computer science is my favorite!"
    """
    words = extract_words(text.lower())
    assert words, 'No words extracted from "' + text + '"'
    layout = '{0:>' + str(len(max(words, key=len))) + '}: {1}'
    for word in extract_words(text.lower()):
        print(layout.format(word, get_word_sentiment(word)))
        

# Phase 2: The geometry of maps

def find_centroid(polygon):
    """Find the centroid of a polygon.

    http://en.wikipedia.org/wiki/Centroid#Centroid_of_polygon
    
    polygon -- A list of positions, in which the first and last are the same

    Returns: 3 numbers; centroid latitude, centroid longitude, and polygon area

    Hint: If a polygon has 0 area, return its first position as its centroid

    >>> p1, p2, p3 = make_position(1, 2), make_position(3, 4), make_position(5, 0)
    >>> triangle = [p1, p2, p3, p1]  # First vertex is also the last vertex
    >>> find_centroid(triangle)
    (3.0, 2.0, 6.0)
    >>> find_centroid([p1, p2, p1])
    (1, 2, 0)
    """
    "*** YOUR CODE HERE ***"
    vertices = len(polygon)
    i = 0
    cx, cy, area = 0, 0, 0
    while i < vertices - 1:
        area -= latitude(polygon[i])*longitude(polygon[i+1]) - latitude(polygon[i+1])*longitude(polygon[i])
        i += 1
    area /= 2
    if area == 0:
        return (latitude(polygon[0]), longitude(polygon[0]), 0)
    else:
        i = 0
        while i < vertices - 1:
            cx -= (latitude(polygon[i])+latitude(polygon[i+1])) * (latitude(polygon[i])*longitude(polygon[i+1])-latitude(polygon[i+1])*longitude(polygon[i]))
            cy -= (longitude(polygon[i])+longitude(polygon[i+1]))* (latitude(polygon[i])*longitude(polygon[i+1])-latitude(polygon[i+1])*longitude(polygon[i]))
            i += 1
        cx, cy = cx/(6*area), cy/(6*area)
        return (cx, cy, area)
    
def find_center(shapes):
    """Compute the geographic center of a state, averaged over its shapes.

    The center is the average position of centroids of the polygons in shapes,
    weighted by the area of those polygons.
    
    Arguments:
    shapes -- a list of lists of polygons

    >>> ca = find_center(us_states['CA'])  # California
    >>> round(latitude(ca), 5)
    37.25389
    >>> round(longitude(ca), 5)
    -119.61439

    >>> hi = find_center(us_states['HI'])  # Hawaii
    >>> round(latitude(hi), 5)
    20.1489
    >>> round(longitude(hi), 5)
    -156.21763
    """
    "*** YOUR CODE HERE ***"
    list_len = len(shapes)
    x, y, i = 0, 0, 0
    while i < list_len:
        x += find_centroid(shapes[i])[0]
        y += find_centroid(shapes[i])[1]
        i += 1
    return (x/list_len, y/list_len)

# Uncomment this decorator during Phase 2.
#@main
def draw_centered_map(center_state='TX', n=10):
    """Draw the n states closest to center_state.
    
    For example, to draw the 20 states closest to California (including California):

    # python3 trends.py CA 20
    """
    us_centers = {n: find_center(s) for n, s in us_states.items()}
    center = us_centers[center_state.upper()]
    dist_from_center = lambda name: geo_distance(center, us_centers[name])
    for name in sorted(us_states.keys(), key=dist_from_center)[:int(n)]:
        draw_state(us_states[name])
        draw_name(name, us_centers[name])
    draw_dot(center, 1, 10)  # Mark the center state with a red dot
    wait()


# Phase 3: The mood of the nation

def find_closest_state(tweet, state_centers):
    """Return the name of the state closest to the given tweet's location.
    
    Use the geo_distance function (already provided) to calculate distance 
    in miles between two latitude-longitude positions.

    Arguments:
    tweet -- a tweet abstract data type
    state_centers -- a dictionary from state names to state shapes

    >>> us_centers = {n: find_center(s) for n, s in us_states.items()}
    >>> sf = make_tweet("Welcome to San Francisco", None, 38, -122)
    >>> ny = make_tweet("Welcome to New York", None, 41, -74)
    >>> find_closest_state(sf, us_centers)
    'CA'
    >>> find_closest_state(ny, us_centers)
    'NJ'
    """
    "*** YOUR CODE HERE ***"
    tweet_pos = make_position(tweet['latitude'], tweet['longitude'])
    minimum = 9999999
    flag = ''
    for item in state_centers:
        if minimum > geo_distance(tweet_pos, state_centers[item]):
            minimum = geo_distance(tweet_pos, state_centers[item])
            flag = item
    return flag

def group_tweets_by_state(tweets):
    """Return a dictionary that aggregates tweets by their nearest state center.

    The keys of the returned dictionary are state names, and the values are
    lists of tweets that appear closer to that state center than any other.
    
    tweets -- a sequence of tweet abstract data types    

    >>> sf = make_tweet("Welcome to San Francisco", None, 38, -122)
    >>> ny = make_tweet("Welcome to New York", None, 41, -74)
    >>> ca_tweets = group_tweets_by_state([sf, ny])['CA']
    >>> tweet_string(ca_tweets[0])
    '"Welcome to San Francisco" @ (38, -122)'
    """
    tweets_by_state = {}
    "*** YOUR CODE HERE ***"
    us_centers = {n: find_center(s) for n, s in us_states.items()}
    tweets_num = len(tweets)
    
    i = 0
    while i < tweets_num:
        tweets_by_state[find_closest_state(tweets[i], us_centers)] = []
        i += 1
    i = 0
    while i < tweets_num:
        tweets_by_state[find_closest_state(tweets[i], us_centers)].append(tweets[i])
        i += 1
    return tweets_by_state

def calculate_average_sentiments(tweets_by_state):
    """Calculate the average sentiment of the states by averaging over all 
    the tweets from each state. Return the result as a dictionary from state
    names to average sentiment values.
   
    If a state has no tweets with sentiment values, leave it out of the
    dictionary entirely.  Do not include a states with no tweets, or with tweets
    that have no sentiment, as 0.  0 represents neutral sentiment, not unknown
    sentiment.

    tweets_by_state -- A dictionary from state names to lists of tweets
    """
    averaged_state_sentiments = {}
    for item in tweets_by_state:
        temp_len, i, total = len(tweets_by_state[item]), 0, 0
        while i < temp_len:
            if analyze_tweet_sentiment(tweets_by_state[item][i]) != None:
                total += analyze_tweet_sentiment(tweets_by_state[item][i])
            i += 1
        if total != None:
            averaged_state_sentiments[item] = total/temp_len
        else:
            averaged_state_sentiments[item] = None
    return averaged_state_sentiments

def draw_state_sentiments(state_sentiments={}):
    """Draw all U.S. states in colors corresponding to their sentiment value.
    
    Unknown state names are ignored; states without values are colored grey.
    
    state_sentiments -- A dictionary from state strings to sentiment values
    """
    for name, shapes in us_states.items():
        sentiment = state_sentiments.get(name, None)
        draw_state(shapes, sentiment)
    for name, shapes in us_states.items():
        center = find_center(shapes)
        if center is not None:
            draw_name(name, center)

# Uncomment this decorator during Phase 3.
@main
def draw_map_for_term(term='Berkeley'):
    """
    Draw the sentiment map corresponding to the tweets that match term.
    
    term -- a word or phrase to filter the tweets by.  
    
    To visualize tweets containing the word "obama":
    
    # python3 trends.py obama
    
    Some term suggestions:
    New York, Texas, sandwich, my life, justinbieber
    """
    tweets = load_tweets(make_tweet, term)
    tweets_by_state = group_tweets_by_state(tweets)
    state_sentiments = calculate_average_sentiments(tweets_by_state)
    draw_state_sentiments(state_sentiments)
    for tweet in tweets:
        draw_dot(tweet_location(tweet), analyze_tweet_sentiment(tweet))
    wait()
