'''Name: Chaoran Yu, Wenhao Cen
   login: cs61a-qq. cs61a-eb
   TA: Steven Tang, Phillip Carpenter
'''

"""A Logo interpreter."""

import sys
from ucb import interact, main, trace
from buffer import Buffer
from logo_parser import parse_line
import logo_primitives

try:
    import readline
except ImportError:
    pass # Readline is not necessary; it's just a convenience

#############
# Evaluator #
#############

def eval_line(line, env):
    """Evaluate a line (buffer) of Logo.
    
    >>> line = Buffer(parse_line('1 2'))
    >>> eval_line(line, Environment())
    '1'
    >>> line = Buffer(parse_line('print 1 2'))
    >>> eval_line(line, Environment())
    1
    '2'
    """
    retn = logo_eval(line,env)
    while not retn and line.current:
        retn = logo_eval(line,env)
    return retn
    


def logo_eval(line, env):
    """Evaluate the first expression in a line.

    >>> line = Buffer(parse_line('sum 1 (sum 2 3)'))
    >>> eval_line(line, Environment())
    '6'
    >>> line = Buffer(parse_line('sum 1 (sum 2 3 4)'))
    >>> eval_line(line, Environment())
    Traceback (most recent call last):
        ...
    logo.LogoError: Expected ")" at [ sum, 1, (, sum, 2, 3 >> 4, ) ]
    """
    arg0 = eval_noninfix(line,env)
    operator = line.current
    if type(operator) == list:
        return arg0
    while operator in INFIX_SYMBOLS:
        line.pop()
        arg1 = eval_noninfix(line,env)
        proc = env.procedures.get(INFIX_SYMBOLS[operator], None)
        new_line = Buffer([INFIX_SYMBOLS[operator],arg0,arg1],0)
        arg0 = eval_noninfix(new_line,env)
        if not new_line.current:
            return arg0
        elif new_line.current in INFIX_SYMBOLS:
            operator = line.pop()
    return arg0
        


def eval_noninfix(line,env):
    def helper(line,env):
        if line.current == None:
            error('Ran out of input at {0}'.format(line))
        elif line.current == ')':
            error('Unexpected ")" at {0}'.format(line))

        token = line.pop()
        if isprimitive(token):
            return token
        elif isvariable(token):
            return env.lookup_variable(variable_name(token))
        elif isdefinition(token):
            return eval_definition(line, env)
        elif isquoted(token):
            return text_of_quotation(token)
        elif token == '(':
            retn = logo_eval(line,env)
            next_token = line.current
            if next_token == ')':
                line.pop()
                return retn
            else:
                error('Expected ")" at '+str(line))
        else:
            procedure = env.procedures.get(token, None)
            if not procedure:
                error('I do not know how to {0}.'.format(token))
            return apply_procedure(procedure, line, env)
    return helper(line,env)


def apply_procedure(proc, line, env):
    """Evaluate the procedure named by token on the args in line."""
    args = collect_args(proc.arg_count, line, env)
    if proc.needs_env:
        args.append(env)
    if len(args) < proc.arg_count:
        error('Not enough args to {0}'.format(proc.name))
    return logo_apply(proc, args)



def collect_args(n, line, env):
    """Evaluate n arguments from the line via recursive calls to logo_eval.
    
    >>> line = Buffer(parse_line('2 sum 3 4'))
    >>> env = Environment()
    >>> collect_args(2, line, env)
    ['2', '7']
    >>> collect_args(1, line, env)
    Traceback (most recent call last):
        ...
    logo.LogoError: Found only 0 of 1 args at [ 2, sum, 3, 4 >>  ]
    """
    total = n
    result = []
    while n > 0:
        if not line.current:
            error('Found only '+str(total-n)+' of '+str(total)+' args at '+str(line))
        result.append(logo_eval(line,env))
        n = n-1
    return result



def logo_apply(proc, args):
    """Apply a Logo procedure to a list of arguments.
    
    >>> body = [['show', ':x'], ['output', 'sum', '1', ':x', ')']]
    >>> proc = Procedure('f', 1, body, needs_env=True, formal_params=['x'])
    >>> args = ['4', Environment()]
    >>> logo_apply(proc, args)
    4
    '5'
    """
    if proc.isprimitive:
        try:
            return proc.body(*args)
        except Exception as e:
            error(e) # Convert any error into a LogoError
    else:
        n = len(args)-1
        i = 0
        new_frame = {}
        while i < n:
            new_frame[proc.formal_params[i]] = args[i]
            i += 1
        args[n].push_frame(new_frame)
        for elem in proc.body:
            result = logo_eval(Buffer((elem)),args[n])
            if result and type(result) != tuple:
                error('You do not say what to do with the '+str(result))
            elif type(result) == tuple and result[0] == 'OUTPUT':
                retn = result[1]
            else:
                retn = result
        args[n].pop_frame()
        return retn




def isoutput(result):
    """Return whether result is a two-element tuple starting with 'OUTPUT'."""
    length_two = type(result) == tuple and len(result) == 2
    return length_two and result[0] == 'OUTPUT'

def isprimitive(token):
    """Numbers, True, and False are primitive, self-evaluating tokens."""
    if token in ('True', 'False'):
        return True
    try:
        float(token)
        return True
    except (TypeError, ValueError):
        return False

def isvariable(exp):
    """Variables start with ":" """
    return type(exp) == str and exp.startswith(':')

def variable_name(exp):
    """Variable names follow the ":" """
    if type(exp) != str or len(exp) <= 1 or exp[0] != ':':
        raise ValueError('Illegal variable expression {0}'.format(exp))
    return exp[1:]

def isdefinition(exp):
    """Definitions start with "to" """
    return exp == "to"

def isquoted(exp):
    """Lists are automatically quoted, and symbols can be explicitly quoted.
    
    >>> isquoted('"hello')
    True
    >>> isquoted('hello')
    False
    >>> isquoted([1, 2])
    True
    """
    if exp[0] == '"':
        return True
    if type(exp) == list:
        return True
    return False # Does not detect quotation

def text_of_quotation(exp):
    """Retrieving the text of a quotation requires stripping the quote.
    
    >>> text_of_quotation('"hello')
    'hello'
    >>> text_of_quotation([1, 2])
    [1, 2]
    """
    if type(exp) == str:
        return exp[1:]
    else:
        return exp


########################
# Primitive Procedures #
########################

def logo_type(x, top_level=True):
    """Apply the "type" primitive, which prints out a value x.
    
    >>> logo_type(['1', '2', ['3', ['4'], '5']])
    1 2 [3 [4] 5]
    >>> line = Buffer(parse_line('type [a [b c] d]'))
    >>> eval_line(line, Environment())
    a [b c] d
    """
    if type(x) != list:
        print(x,end='') # The end argument prevents starting a new line
    else:
        if top_level:
            top_level = False
            i = 0
            while i < len(x):
                if i != 0:
                    print(' ',end='')
                    logo_type(x[i],top_level)
                else:
                    logo_type(x[i],top_level)
                i = i+1
        else:
            print('[', end='')
            i = 0
            while i < len(x):
                if i != 0:
                    print(' ',end='')
                    logo_type(x[i],top_level)
                else:
                    logo_type(x[i],top_level)
                i = i+1
            print(']', end='')
                
        

def logo_run(exp, env):
    """Apply the "run" primitive."""
    if type(exp) != list:
        exp = [exp]
    return eval_line(Buffer(exp), env)



def logo_if(val, exp, env):
    """Apply the "if" primitive, which takes a boolean and a list.
    
    ***YOUR DOCTEST HERE***
    """
    result = logo_eval(Buffer([val]),env)
    if result != 'True' and result != 'False':
        error('First argument to "if" is not True or False: '+str(result))
    else:
        if result == 'True':
            if type(exp) == list:
                return logo_eval(Buffer(exp),env)
            else:
                return exp
    

def logo_ifelse(val, true_exp, false_exp, env):
    """Apply the "ifelse" primitive, which takes a boolean and two lists.
    
    ***YOUR DOCTEST HERE***
    """
    result = logo_eval(Buffer([val]),env)
    if result != 'True' and result != 'False':
        error('First argument to "if" is not True or False: '+str(result))
    else:
        if result == 'True':
            if type(true_exp) == list:
                return logo_eval(Buffer(true_exp),env)
            else:
                return true_exp
        else:
            if type(false_exp) == list:
                return logo_eval(Buffer(false_exp),env)
            else:
                return false_exp
            
    
    
    
def logo_make(symbol, val, env):
    """Apply the Logo make primitive, which binds a name to a value.
    
    >>> line = Buffer(parse_line('make "2 3'))
    >>> env = Environment(None)
    >>> eval_line(line, env)
    >>> env.lookup_variable('2')
    '3'
    """
    env.set_variable_value(symbol, val)

# A dict mapping infix symbols to Logo primitive procedure names.
INFIX_SYMBOLS = {'+': 'sum',
                 '-': 'difference',
                 '*': 'product',
                 '/': 'div',
                 '=': 'equalp',
                 '>': 'greaterp',
                 '<': 'lessp',
                 }

# Precedence levels
INFIX_GROUPS = [['<', '>', '='], ['+', '-'], ['*', '/']]

#################################
# Procedures and Initialization #
#################################

class Procedure(object):
    """A Logo procedure, either primitive or user-defined.

    name: The name of the procedure.  For primitive procedures with multiple
          names, only one is stored here.

    arg_count: Number of arguments required by the procedure.

    body: A Logo procedure body is either:
            a Python function, if isprimitive == True
            a list of lines,   if isprimitive == False

    isprimitive: whether the procedure is primitive.

    needs_env: whether the environment should be passed as an add'l parameter.

    formal_params: list of formal parameter names (user-defined procedures).
    """
    def __init__(self, name, arg_count, body, isprimitive=False,
                 needs_env=False, formal_params=None):
        self.name = name
        self.arg_count = arg_count
        self.body = body
        self.isprimitive = isprimitive
        self.needs_env = needs_env
        if not formal_params:
            formal_params = [str(i) for i in range(arg_count)]
        self.formal_params = formal_params

    def __str__(self):
        params = ':'.join([''+p for p in self.formal_params])
        return 'to {0} {1}'.format(self.name, params)

def load_primitives():
    """Load primitive Logo procedures."""
    primitives = dict()

    def make_primitive(names, arg_count, fn, **kwds):
        """Create primitive procedures for names."""
        if type(names) == str:
            names = [names]
        kwds['isprimitive'] = True
        procedure = Procedure(names[0], arg_count, fn, **kwds)
        for name in names:
            primitives[name] = procedure

    logo_primitives.load(make_primitive)
    make_primitive('type', 1, logo_type)
    make_primitive('make', 2, logo_make, needs_env=True)
    make_primitive('if', 2, logo_if, needs_env=True)
    make_primitive('ifelse', 3, logo_ifelse, needs_env=True)

    make_primitive('output', 1, lambda x: ('OUTPUT', x))
    make_primitive('stop', 0, lambda: ('OUTPUT', None))
    make_primitive('run', 1, logo_run, needs_env=True)
    return primitives


############################################
# Environments and User-Defined Procedures #
############################################

class Environment(object):
    """An environment holds procedure (global) and name bindings in frames."""
    def __init__(self, get_continuation_line=None):
        self.get_continuation_line = get_continuation_line
        self.procedures = load_primitives()
        self._frames = [dict()] # The first frame is the global one

    def push_frame(self, frame):
        """Add a new frame, which contains new bindings."""
        self._frames.append(frame)

    def pop_frame(self):
        """Discard the last frame."""
        self._frames.pop()

    def lookup_variable(self, symbol):
        """Look up a variable in the environment, or raise an error.
        
        >>> env = Environment()
        >>> env.set_variable_value('x', 1)
        >>> env.push_frame({'x': 2, 'y': 3})
        >>> env.push_frame({'y': 4})
        >>> env.lookup_variable('y')
        4
        >>> env.lookup_variable('x')
        2
        >>> env.lookup_variable('z')
        Traceback (most recent call last):
            ...
        logo.LogoError: z has no value
        """
        i = len(self._frames)-1
        while (symbol not in self._frames[i]) and i > 0:
            i -= 1
        if (i == 0) and (not symbol in self._frames[0]):
            error(str(symbol)+' has no value')
        else:
            return self._frames[i][symbol] 



    def set_variable_value(self, symbol, val):
        """Set the value of a variable in the innermost frame where it's defined,
        or create it in the global frame.
        
        >>> env = Environment()
        >>> env.set_variable_value('x', 1)
        >>> env.push_frame({'x': 2, 'y': 3})
        >>> env.set_variable_value('x', 4)
        >>> env.lookup_variable('x')
        4
        >>> env.set_variable_value('z', 5)
        >>> env.lookup_variable('z')
        5
        >>> env.pop_frame()
        >>> env.lookup_variable('x')
        1
        >>> env.lookup_variable('z')
        5
        """
        i = len(self._frames)-1
        while (not symbol in self._frames[i]) and i > 0:
            i -= 1
        self._frames[i][symbol] = val


    def __str__(self):
        return ';'.join([str(f) for f in self._frames])


def eval_definition(line, env):
    """Evaluate a definition and return a corresponding procedure.

    line: The definition line, following "to", of the multi-line definition.

    Hint: create a user-defined Procedure object using
          Procedure(name, len(params), body, formal_params=params, needs_env=True)
            - name is a string defining the procedure name
            - body is a list of Buffer objects (one per line of source code)
            - params is a list of strings defining the name of each formal parameter
            - needs_env is always True

    >>> to_line = Buffer(parse_line('to double :n'))
    >>> body = ['output sum :n :n\\n', 'end']
    >>> env = Environment(generate_lines(body, '>'))
    >>> eval_line(to_line, env)
    > output sum :n :n
    > end
    >>> print(env.procedures['double'])
    to double :n
    >>> env.procedures['double'].needs_env
    True
    >>> env.procedures['double'].body
    [['output', 'sum', ':n', ':n']]
    """
    procedure_name = line.pop()
    para_len = 0
    params = []
    while line.current:
        para_len += 1
        params.append(line.pop())
    next_line = lambda: parse_line(env.get_continuation_line())
    body = []
    new_line = next_line()
    while new_line != ['end']:
        body += new_line
        new_line = next_line()
    body = [body]
    new_proc = Procedure(procedure_name,para_len,body,isprimitive=False,needs_env=True,formal_params=params)
    env.procedures[procedure_name] = new_proc




###############
# Interpreter #
###############

class LogoError(Exception):
    """An error raised by the Logo interpreter."""

def error(message):
    """Raise a Logo error as a Python exception."""
    raise LogoError(message)

def interpret_line(line, env):
    """Interpret a single line in the read-eval loop."""
    result = eval_line(Buffer(parse_line(line)), env)
    if result is not None:
        error('You do not say what to do with {0}.'.format(result))
    
def read_eval_loop(env, get_next_line):
    """Run a read-eval loop for Logo.

    get_next_line: a zero-argument fn that returns a line of Logo code (str).
    """
    while True:
        try:
            line = get_next_line()
            if line.lower() in {'quit', 'exit', 'bye'}:
                raise EOFError
            interpret_line(line, env)
        except (LogoError, SyntaxError) as err:
            print(err)
        except (KeyboardInterrupt, EOFError):
            print('Goodbye!')
            return

def strip_comment(line):
    """Return the prefix of line preceding the first semicolon."""
    return line.split(';', 1)[0]

def prompt_for_line(prompt='?'):
    """Read a line interactively from the user (via standard input)."""
    return strip_comment(input(prompt + ' '))

def generate_lines(src, prompt='?'):
    """Return a function that returns lines from src, a list of strings."""
    def pop_line():
        if not src:
            raise EOFError
        line = src.pop(0)
        print(prompt, line, end='')
        return strip_comment(line)
    return pop_line

@main
def run_interpreter(src_file=None):
    """Run a read-eval loop that reads from either a prompt or a file."""
    get_next_line = prompt_for_line
    get_continuation_line = lambda: prompt_for_line('>')
    if src_file != None:
        src = open(src_file).readlines()
        get_next_line = generate_lines(src)
        get_continuation_line = generate_lines(src, prompt='>')
    env = Environment(get_continuation_line)
    read_eval_loop(env, get_next_line)
