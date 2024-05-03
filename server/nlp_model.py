
import textwrap
from os import system
import google.generativeai as genai
from IPython.display import display
from IPython.display import Markdown
    
def tokenize_output(input_content , open_tag ,close_tag , separator ):
    
    open_brackets = False
    string = ""
    token_list = []
    for s in input_content:
        
        if s == open_tag:
            open_brackets = True
            continue
        
        if s == close_tag and open_brackets:
            
            if string != "":
                token_list.append(string)
            
            break
        
        if open_brackets:
            
            if s == separator:
                token_list.append(string)
                string = ""
                continue
            
            string += s
            
    
    return token_list

def action_list(token_list):

    action_list = []
    for item in token_list:
        
        my_list = str(item).split("(")
        
        actions = tokenize_output( item , "(",")","," )
        action_list.append( { "action": my_list[0] , "params": actions } )
    
        pass

    return action_list

def generate_api_key():

    genai.configure(api_key="AIzaSyDB74YrixiIRt_tE3phg3bZBHOiNynBH3I")

def ask_AI( 
           player_situation="",
           walls="[(1,2),(2,3),(4,5),(6,7),(8,9)]" , 
           row_length= 12,
           column_length= 12,
           functions="[go(x,y)]" ,
           params_explanation="x is the row of a matrix , y is the column of the same matrix " ,
           enemy_positions="[[my name is 20 and I am at position: (3,1)],[my name is 23 and I am at position:(5,6)]]" , 
           ally_positions="[[my name is 45 and I am at position:(3,1)],[my name is 78 and I am at position:(5,6)]]" , 
           my_flag_position= "(0,0)" ,
           enemy_flag_position="[(4,2)]" , example_output="go to (4,5)" ):

    generate_api_key()

    model = genai.GenerativeModel('gemini-pro')

    content = f" you are a commander in a battle the map is {row_length}x{column_length} grid , you are placed in a map in which there are numbered walls  , \
            roads and two flags. One of these flags are yours and the other flag is your enemy'flag. Your goal is to reach the enemy'flag , \
            but the enemy can not reach yours. You have one soldier that responds to your command, and the enemy is composed of a commander and \
            one soldier to which such commander gives orders. You and your soldier can do the next actions: \
            {functions} \
            {params_explanation} \
            one of your soldiers says: {player_situation} \
            example input: \
            soldier_situacion: I need to conquer flag \
            your_flag = [(1,1)] \
            your_position = [ \"my name is 17 and I am at position: \" (0,0) ] \
            wall = [(1,2),(2,3),(4,5),(6,7),(8,9)] \
            enemy_flag_position: [\"my name is 57 and I am at position: \"(12,12)] \
            enemy_postion = [(1,12) , (4,9)] \
            example of output: \
            {example_output} \
            the input is: \
            {my_flag_position} \
            {ally_positions} \
            {walls} \
            {enemy_flag_position} \
            {enemy_positions} \
            output: "

    response = model.generate_content(content)
    
    return response.text