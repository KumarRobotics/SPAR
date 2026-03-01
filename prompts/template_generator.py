"""
A script to generate different types of prompt templates.
"""
import os
import re


class TemplateGenerator:
    """
    A class to generate prompt templates for different tasks.
    """

    def __init__(self, method):
        self.method = method


    #####################################  building blocks #####################################

    def classical_head(self):
        return """You are defining the preconditions and effects (represented in PDDL format) of an AI agent's actions. Information about the AI agent will be provided in the domain description. Note that individual conditions in preconditions and effects should be listed separately. For example, "object_1 is washed and heated" should be considered as two separate conditions "object_1 is washed" and "object_1 is heated". Also, in PDDL, two predicates/functions cannot have the same name even if they have different parameters. Each predicate/function in PDDL must have a unique name, and its parameters must be explicitly defined in the predicate/function definition. It is recommended to define predicate/function names in an intuitive and readable way."""


    def task_generate_instruction(self):
        return """
Here is the task.

Domain information: {domain_desc}

Action: {action_desc}

You can only use the following types for objects: 
{types}"""


    def parse_best_example_no_cot(self, example_headers, similar_domain_prompt_example, similar_action_idx):
        """
        parse the best example from the similar domain prompt example without cot.
        """
        
        similar_example = similar_domain_prompt_example[example_headers[similar_action_idx].end():example_headers[similar_action_idx + 1].start() if similar_action_idx + 1 < len(example_headers) else None].strip() 
        return similar_example
    

    def parse_action_desc_fluent_list(self, example_headers, similar_domain_prompt_example, similar_action_idx):
        """
        Parse the action description and fluent list from the similar domain prompt example.
        """
        similar_output_example = similar_domain_prompt_example[example_headers[similar_action_idx].end():example_headers[similar_action_idx + 1].start() if similar_action_idx + 1 < len(example_headers) else None].strip() 

        pattern = r"(?m)^Parameters:"
        match = re.search(pattern, similar_output_example)
        if match:
            return similar_output_example[:match.start()]

        return None
    

    def parse_llm_output_format(self, example_headers, similar_domain_prompt_example, similar_action_idx):
        """
        Parse the LLM output format from the similar domain prompt example.
        """
        similar_output_example = similar_domain_prompt_example[example_headers[similar_action_idx].end():example_headers[similar_action_idx + 1].start() if similar_action_idx + 1 < len(example_headers) else None].strip() 

        pattern = r"(?m)^Parameters:"
        match = re.search(pattern, similar_output_example)
        if match:
            return similar_output_example[match.start():]
        
        return None


    def parse_best_example_with_cot_no_header(self, example_headers, similar_domain_cot_example, similar_action_idx):
        """
        In this case, we throw away the header of the example, and only keep the content of the example.
        starting with: Let's think step by step and answer...... 
        """
        start_idx = example_headers[similar_action_idx].end()
        end_idx = example_headers[similar_action_idx + 1].start() if similar_action_idx + 1 < len(example_headers) else None
        after_header = similar_domain_cot_example[start_idx:end_idx]
        next_line_start = after_header.find("\n") + 1  # skip the current line
        cot_example = after_header[next_line_start:].strip()

        return cot_example




##################################           various prompt templates        ##################################


    def basic_cook_examples(self):
        return """
Domain information: Cook is a planning domain in artificial intelligence. The AI agent here is a robot that can cook food in the kitchen. The robot can perform actions such as washing, cutting, and cooking ingredients to prepare a meal.

Example 1. Robot cooks breakfast at the kitchen
Action: robot can start to cook eggs if both the robot and egges are at the kitchen, and if the stove is on, the temperature of stove is higher than specific value. This action will cost 4 units of energy cost. For example, if robot has eggs and at the kitchen, and if the stove temperature is 30 units higher than the required temperature for cooking the eggs, then robot can cook the egges and cost 4 units of energy.

You can create and define new predicates, but you may also reuse the following predicates:
1. (at ?r - robot ?k - kitchen): true if the robot ?r is at the kitchen ?k
2. (off ?stove - appliance): true if the stove ?stove is off
3. (working ?stove - appliance): true if the stove ?stove is working

You can create and define new functions, but you may also reuse the following functions:
1. (cost ?r - robot): the total cost of robot ?r

Parameters:
1. ?r - robot: the robot
2. ?k - kitchen: the current kitchen
3. ?stove - appliance: the stove 
4. ?eggs - ingredient: the eggs to cook

Preconditions:
```
(and
    (at ?r ?k)
    (has-ingredient ?r ?egg)
    (working ?stove)
    (> (stove-temperature ?stove) (required-temperature ?stove))
)
```

Effects:
```
(and
    (breakfast-ready ?k)
    (not (has-ingredient ?r ?egg))
    (increase (cost ?r) 4)
)
```

New Predicates:(Please write: "No newly defined predicate" below if there is no new predicate)
1. (has-ingredient ?r - robot ?egg - ingredient): true if robot ?r has the ingredient ?egg
2. (breakfast-ready ?k - kitchen): true if breakfast is ready at the kitchen ?k

New Functions:(Please write: "No newly defined function" below if there is no new function)
1. (stove-temperature ?stove): the temperature of the stove ?stove
2. (required-temperature ?stove): the required temperature for cooking on the stove ?stove
"""



    def basic_cot_cook_examples(self):
        return """
Domain information: Cook is a planning domain in artificial intelligence. The AI agent here is a robot that can cook food in the kitchen. The robot can perform actions such as washing, cutting, and cooking ingredients to prepare a meal.

Example 1. Robot cooks breakfast at the kitchen
Action: robot can start to cook eggs if both the robot and egges are at the kitchen, and if the stove is on, the temperature of stove is higher than specific value. This action will cost 4 units of energy cost. For example, if robot has eggs and at the kitchen, and if the stove temperature is 30 units higher than the required temperature for cooking the eggs, then robot can cook the egges and cost 4 units of energy.

You can create and define new predicates, but you may also reuse the following predicates:
1. (at ?r - robot ?k - kitchen): true if the robot ?r is at the kitchen ?k
2. (off ?stove - appliance): true if the stove ?stove is off
3. (working ?stove - appliance): true if the stove ?stove is working

You can create and define new functions, but you may also reuse the following functions:
1. (cost ?r - robot): the total cost of robot ?r

Let's think step by step and answer the following questions. Your output should be strictly following this format:

- According to the description, what are the objects involved in this action?
1. the robot ?r
2. the current kitchen ?k
3. the stove ?stove
4. the eggs to cook ?eggs

- For each object, what are the preconditions? state them using predicates or functions (reused or newly created)
1. the robot ?r:
    - Is at the current kitchen - (at ?r ?k)
    - Has the ingredient eggs - (has-ingredient ?r ?eggs)
2. the current kitchen ?k:
    - None
3. the stove ?stove:
    - Is on - (working ?stove)
    - Temperature is higher than the required temperature - (> (stove-temperature ?stove) (required-temperature ?stove))
4. the eggs to cook ?eggs:
    - None

- For each object, what are the effects? state them using predicates or functions (reused or newly created)
1. the robot ?r:
    - No long has the ingredient eggs - (not (has-ingredient ?r ?egg))
    - Increase the cost of robot - (increase (cost ?r) 4)
2. the current kitchen ?k:
    - The breakfast is ready at this kitchen - (breakfast-ready ?k)
3. the stove ?stove:
    - None
4. the eggs to cook ?eggs:
    - None

- Finally, write the action in following format:

Parameters:
1. ?r - robot: the robot
2. ?k - kitchen: the current kitchen
3. ?stove - appliance: the stove 
4. ?eggs - ingredient: the eggs to cook

Preconditions:
```
(and
    (at ?r ?k)
    (has-ingredient ?r ?egg)
    (working ?stove)
    (> (stove-temperature ?stove) (required-temperature ?stove))
)
```

Effects:
```
(and
    (breakfast-ready ?k)
    (not (has-ingredient ?r ?egg))
    (increase (cost ?r) 4)
)
```

New Predicates:(Please write: "No newly defined predicate" below if there is no new predicate)
1. (has-ingredient ?r - robot ?egg - ingredient): true if robot ?r has the ingredient ?egg
2. (breakfast-ready ?k - kitchen): true if breakfast is ready at the kitchen ?k

New Functions:(Please write: "No newly defined function" below if there is no new function)
1. (stove-temperature ?stove): the temperature of the stove ?stove
2. (required-temperature ?stove): the required temperature for cooking on the stove ?stove
"""




    def basic_blockworld_examples(self):
        return """
Here are two examples from the robot cooking domain to demonstrate the output format.

Domain information: Cook is a planning domain in artificial intelligence. The AI agent here is a robot that can cook food in the kitchen. The robot can perform actions such as washing, cutting, and cooking ingredients to prepare a meal.

Example 1. Robot turns on the stove
Action: This action enables the robot to turn on the stove if stove is not turned on yet. This action will incur one unit cost. For example, the robot turns on the stove, the cost will be increased by 1.

You can create and define new predicates, but you may also reuse the following predicates:
No predicate has been defined yet

You can create and define new functions, but you may also reuse the following functions:
No function has been defined yet

Parameters:
1. ?r - robot: the robot
2. ?k - kitchen: the current kitchen
3. ?stove - appliance: the stove

Preconditions:
```
(and
    (at ?r ?k)
    (off ?stove)
)
```

Effects:
```
(and
    (working ?stove)
    (not (off ?stove))
    (increase (cost ?r) 1)
)
```

New Predicates:(Please write: "No newly defined predicate" below if there is no new predicate)
1. (at ?r - robot ?k - kitchen): true if the robot ?r is at the kitchen ?k
2. (off ?stove - appliance): true if the stove ?stove is off
3. (working ?stove - appliance): true if the stove ?stove is working

New Functions:(Please write: "No newly defined function" below if there is no new function)
1. (cost ?r): the total cost of robot ?r


Example 2. Robot cooks breakfast at the kitchen
Action: robot can start to cook eggs if both the robot and egges are at the kitchen, and if the stove is on, the temperature of stove is higher than specific value. This action will cost 4 units of energy cost. For example, if robot has eggs and at the kitchen, and if the stove temperature is 30 units higher than the required temperature for cooking the eggs, then robot can cook the egges and cost 4 units of energy.

You can create and define new predicates, but you may also reuse the following predicates:
1. (at ?r - robot ?k - kitchen): true if the robot ?r is at the kitchen ?k
2. (off ?stove - appliance): true if the stove ?stove is off
3. (working ?stove - appliance): true if the stove ?stove is working

You can create and define new functions, but you may also reuse the following functions:
1. (cost ?r - robot): the total cost of robot ?r

Parameters:
1. ?r - robot: the robot
2. ?k - kitchen: the current kitchen
3. ?stove - appliance: the stove 
4. ?eggs - ingredient: the eggs to cook

Preconditions:
```
(and
    (at ?r ?k)
    (has-ingredient ?r ?egg)
    (working ?stove)
    (> (stove-temperature ?stove) (required-temperature ?stove))
)
```

Effects:
```
(and
    (breakfast-ready ?k)
    (not (has-ingredient ?r ?egg))
    (increase (cost ?r) 4)
)
```

New Predicates:(Please write: "No newly defined predicate" below if there is no new predicate)
1. (has-ingredient ?r - robot ?egg - ingredient): true if robot ?r has the ingredient ?egg
2. (breakfast-ready ?k - kitchen): true if breakfast is ready at the kitchen ?k

New Functions:(Please write: "No newly defined function" below if there is no new function)
1. (stove-temperature ?stove): the temperature of the stove ?stove
2. (required-temperature ?stove): the required temperature for cooking on the stove ?stove
"""



    def basic_blockworld_prompt(self):
        """
        Generate: Basic version of Prompt -> Block world example without COT.
        """
        return self.classical_head() + '\n' + self.basic_blockworld_examples() + '\n\n' + self.task_generate_instruction()



    def basic_best_prompt(self, similar_domain_prompt_example
                        , similar_action_idx
                        , similar_domain_desc):
        """
        one Basic examples for format
        one best example for reference
        """

        template = """
You are given a domain description and an action description. Your task is to define the preconditions and effects of this action using PDDL format. You should either reuse or create appropriate predicates and functions to accurately express the logic of the action. Individual conditions in preconditions and effects should be listed separately. Each predicate/function in PDDL must have a unique name, and its parameters must be explicitly defined in the predicate/function definition. Make sure all names are intuitive, readable, and consistent with the domain context.

To guide your generation, you will be shown two examples from two domains:
1. Format Example: The first example demonstrates the expected structure and formatting. Please follow this output format strictly. Do NOT output any other explanation or reasoning.
2. Similar Action Example: The second example provides a reference that is semantically close to your task. You may draw inspiration from it, but do NOT copy. Instead, generate your output based on the given action description and domain description.\n"""
    
        #template += self.basic_blockworld_examples()

        template += """
The first example below demonstrates the expected output format.
"""

        template += self.basic_cook_examples()

        template += "\n"

        template += """
Now the second example is from a different domain, it is semantically close to your task for your reference. You may draw inspiration from it, but do NOT copy. Instead, generate your output based on the given action description and domain description.
        """
        example_headers = list(re.finditer(r'Example\s+(\d+). ', similar_domain_prompt_example))
        similar_example = self.parse_best_example_no_cot(example_headers, similar_domain_prompt_example, similar_action_idx)
        
        template += f"""
Domain Information: {similar_domain_desc}\n"""
        
        template += "\n"

        template += "Example 1. " + similar_example

        template += "\n"

        template += self.task_generate_instruction()
        
        return template





    def two_consist_best_prompt(self, similar_domain_prompt_example
                        , similar_action_idx
                        , similar_domain_desc):
        """
        Generate: Best version of Prompt -> Use the similar domain as example.
        similar_domain_prompt_example:  the prompt example of the similar domain
        similar_action_name: the name of the similar action in this domain
        similar_domain_desc: desc of similar domain
        """
        
        template = """
You are given a domain description and an action description. Your task is to define the preconditions and effects of this action using PDDL format. You should either reuse or create appropriate predicates and functions to accurately express the logic of the action. Individual conditions in preconditions and effects should be listed separately. Each predicate/function in PDDL must have a unique name, and its parameters must be explicitly defined in the predicate/function definition. Make sure all names are intuitive, readable, and consistent with the domain context.

To guide your generation, you will be shown two examples from the same domain:
1. Format Example: Demonstrates the expected structure and formatting. Please follow this format strictly.
2. Similar Action Example: Provides a reference that is semantically close to your task. You may draw inspiration from it, but do not copy. Instead, generate your output based on the given action description and domain description.\n"""
        
        example_headers = list(re.finditer(r'Example\s+(\d+). ', similar_domain_prompt_example))
        ############ if it has only one action example:
        if len(example_headers) == 1:
            format_example_idx = 0
            similar_example_idx = 0
 
        else:
            
            if similar_action_idx == 0:
                format_example_idx = 1
                similar_example_idx = 0
            else:
                format_example_idx = similar_action_idx - 1
                similar_example_idx = similar_action_idx
        
        format_example = self.parse_best_example_no_cot(example_headers, similar_domain_prompt_example, format_example_idx)
        similar_example = self.parse_best_example_no_cot(example_headers, similar_domain_prompt_example, similar_example_idx)
                
        
        template += f"""
Example domain information: {similar_domain_desc} 

Format Example: {format_example} 

Similar Action Example: {similar_example} \n\n """
        
        template += self.task_generate_instruction()
        
        return template
    

    


    def top1_2_best_prompt(self, top1_domain_prompt_example, top2_domain_prompt_example
                        , top1_similar_action_idx, top2_similar_action_idx
                        , top1_similar_domain_desc, top2_similar_domain_desc):
        """
        two top 1, 2 examples for reference, examples are from different domains
        """

        template = """
You are given a domain description and an action description. Your task is to define the preconditions and effects of this action using PDDL format. You should either reuse or create appropriate predicates and functions to accurately express the logic of the action. Individual conditions in preconditions and effects should be listed separately. Each predicate/function in PDDL must have a unique name, and its parameters must be explicitly defined in the predicate/function definition. Make sure all names are intuitive, readable, and consistent with the domain context.

To guide your generation, you will be shown two examples from two domains. They both provide references that are semantically close to your task. You may draw inspiration from them, but do not copy. Instead, generate your output based on the given action description and domain description. Your output should also strictly follow the example.\n"""

        top1_example_headers = list(re.finditer(r'Example\s+(\d+). ', top1_domain_prompt_example))
        top1_example = self.parse_best_example_no_cot(top1_example_headers, top1_domain_prompt_example, top1_similar_action_idx)
        
        top2_example_headers = list(re.finditer(r'Example\s+(\d+). ', top2_domain_prompt_example))
        top2_example = self.parse_best_example_no_cot(top2_example_headers, top2_domain_prompt_example, top2_similar_action_idx)
        
        template += f"""
Example 1 domain information: {top1_similar_domain_desc} """
        
        template += "\n\n"

        template += "Example 1: " + top1_example

        template += "\n\n"


        template += f"""
Example 2 domain information: {top2_similar_domain_desc} """
        
        template += "\n\n"

        template += "Example 2: " + top2_example
        
        template += "\n\n"

        template += self.task_generate_instruction()
        
        return template


############### adding cot examples here ############################


    def two_basic_blockworld_cot_examples(self):
        
        return """
Here are two examples from the robot cooking domain to demonstrate the output format.

Domain information: Cook is a planning domain in artificial intelligence. The AI agent here is a robot that can cook food in the kitchen. The robot can perform actions such as washing, cutting, and cooking ingredients to prepare a meal.

Example 1. Robot turns on the stove
Action: This action enables the robot to turn on the stove if stove is not turned on yet. This action will incur one unit cost. For example, the robot turns on the stove, the cost will be increased by 1.

You can create and define new predicates, but you may also reuse the following predicates:
No predicate has been defined yet

You can create and define new functions, but you may also reuse the following functions:
No function has been defined yet

Let's think step by step and answers the following questions. Your output should be strictly following this format:

- What are the objects?
1. the robot ?r
2. the current kitchen ?k
3. the stove ?stove

- For each object, what are the preconditions? state them using predicates or functions (reused or newly created)
1. the robot ?r:
    - Is at the current kitchen - (at ?r ?k)
2. the current kitchen ?k:
    - None
3. the stove ?stove:
    - Is off - (off ?stove)

- For each object, what are the effects? state them using predicates or functions (reused or newly created)
1. the robot ?r:
    - Cost of robot is increased by 1 - (increase (cost ?r) 1)
2. the current kitchen ?k:
    - None
3. the stove ?stove:
    - Is now working - (working ?stove)
    - Is no longer off - (not (off ?stove))

- Finally, write the action in following format:

Parameters:
1. ?r - robot: the robot
2. ?k - kitchen: the current kitchen
3. ?stove - appliance: the stove

Preconditions:
```
(and
    (at ?r ?k)
    (off ?stove)
)
```

Effects:
```
(and
    (working ?stove)
    (not (off ?stove))
    (increase (cost ?r) 1)
)
```

New Predicates:(Please write: "No newly defined predicate" below if there is no new predicate)
1. (at ?r - robot ?k - kitchen): true if the robot ?r is at the kitchen ?k
2. (off ?stove - appliance): true if the stove ?stove is off
3. (working ?stove - appliance): true if the stove ?stove is working

New Functions:(Please write: "No newly defined function" below if there is no new function)
1. (cost ?r): the total cost of robot ?r


Example 2. Robot cooks breakfast at the kitchen
Action: robot can start to cook eggs if both the robot and egges are at the kitchen, and if the stove is on, the temperature of stove is higher than specific value. This action will cost 4 units of energy cost. For example, if robot has eggs and at the kitchen, and if the stove temperature is 30 units higher than the required temperature for cooking the eggs, then robot can cook the egges and cost 4 units of energy.

You can create and define new predicates, but you may also reuse the following predicates:
1. (at ?r - robot ?k - kitchen): true if the robot ?r is at the kitchen ?k
2. (off ?stove - appliance): true if the stove ?stove is off
3. (working ?stove - appliance): true if the stove ?stove is working

You can create and define new functions, but you may also reuse the following functions:
1. (cost ?r - robot): the total cost of robot ?r

Let's think step by step and answer the following questions. Your output should be strictly following this format:

- According to the description, what are the objects involved in this action?
1. the robot ?r
2. the current kitchen ?k
3. the stove ?stove
4. the eggs to cook ?eggs

- For each object, what are the preconditions? state them using predicates or functions (reused or newly created)
1. the robot ?r:
    - Is at the current kitchen - (at ?r ?k)
    - Has the ingredient eggs - (has-ingredient ?r ?eggs)
2. the current kitchen ?k:
    - None
3. the stove ?stove:
    - Is on - (working ?stove)
    - Temperature is higher than the required temperature - (> (stove-temperature ?stove) (required-temperature ?stove))
4. the eggs to cook ?eggs:
    - None

- For each object, what are the effects? state them using predicates or functions (reused or newly created)
1. the robot ?r:
    - No long has the ingredient eggs - (not (has-ingredient ?r ?egg))
    - Increase the cost of robot - (increase (cost ?r) 4)
2. the current kitchen ?k:
    - The breakfast is ready at this kitchen - (breakfast-ready ?k)
3. the stove ?stove:
    - None
4. the eggs to cook ?eggs:
    - None

- Finally, write the action in following format:

Parameters:
1. ?r - robot: the robot
2. ?k - kitchen: the current kitchen
3. ?stove - appliance: the stove 
4. ?eggs - ingredient: the eggs to cook

Preconditions:
```
(and
    (at ?r ?k)
    (has-ingredient ?r ?egg)
    (working ?stove)
    (> (stove-temperature ?stove) (required-temperature ?stove))
)
```

Effects:
```
(and
    (breakfast-ready ?k)
    (not (has-ingredient ?r ?egg))
    (increase (cost ?r) 4)
)
```

New Predicates:(Please write: "No newly defined predicate" below if there is no new predicate)
1. (has-ingredient ?r - robot ?egg - ingredient): true if robot ?r has the ingredient ?egg
2. (breakfast-ready ?k - kitchen): true if breakfast is ready at the kitchen ?k

New Functions:(Please write: "No newly defined function" below if there is no new function)
1. (stove-temperature ?stove): the temperature of the stove ?stove
2. (required-temperature ?stove): the required temperature for cooking on the stove ?stove
"""




    def basic_cot_prompt(self):
        """
        Basic two blockworld examples with COT.
        """
        template = self.classical_head() + "\n" + self.two_basic_blockworld_cot_examples()

        template += self.task_generate_instruction()

        return template
    


    def basic_cot_best_prompt(self, similar_domain_prompt_cot_example 
                              ,similar_domain_prompt_example
                            , similar_action_idx
                            , similar_domain_desc):
        """
        one basic cot examples for format
        one best cot example for reference,
        """

        template = """
You are given a domain description and an action description. Your task is to define the preconditions and effects of this action using PDDL format. You should either reuse or create appropriate predicates and functions to accurately express the logic of the action. Individual conditions in preconditions and effects should be listed separately. Each predicate/function in PDDL must have a unique name, and its parameters must be explicitly defined in the predicate/function definition. Make sure all names are intuitive, readable, and consistent with the domain context.

To guide your generation, you will be shown two examples from two domains:
1. Format Example: The first example demonstrates the expected structure and formatting. Please follow this format strictly. Do NOT output any other explanation or reasoning.
2. Similar Action Example: The third example in different domain provides a reference that is semantically close to your task. You may draw inspiration from it, but do NOT copy. Instead, generate your output based on the given action description and domain description.\n"""

        # template += self.two_basic_blockworld_cot_examples()

        template += """
The first example below demonstrates the expected output format.
"""

        template += self.basic_cot_cook_examples()

        template += """
Now the last example is from a different domain, it is semantically close to your task for your reference. You may draw inspiration from it, but do NOT copy. Instead, generate your output based on the given action description and domain description.
        """
        cot_example_headers = list(re.finditer(r'Example\s+(\d+). ', similar_domain_prompt_cot_example))
        similar_cot_example = self.parse_best_example_with_cot_no_header(cot_example_headers, similar_domain_prompt_cot_example, similar_action_idx)

        example_headers = list(re.finditer(r'Example\s+(\d+). ', similar_domain_prompt_example))
        similar_output_PDDL_example = self.parse_llm_output_format(example_headers, similar_domain_prompt_example, similar_action_idx)
        example_header = self.parse_action_desc_fluent_list(example_headers, similar_domain_prompt_example, similar_action_idx)
        
        template += f"""
Domain information: {similar_domain_desc} \n"""
        
        template += "\n"

        template += "Example 1. " + example_header

        template += similar_cot_example

        template += "\n\n"

        template += similar_output_PDDL_example

        template += "\n"

        template += self.task_generate_instruction()
        
        return template
    


    def consist_best_cot_prompt(self, similar_domain_prompt_cot_example 
                                    ,similar_domain_prompt_example
                                    , similar_action_idx
                                    , similar_domain_desc):
        """
        best two examples with cot, both are from the same domain.
        """

        template = """
You are given a domain description and an action description. Your task is to define the preconditions and effects of this action using PDDL format. You should either reuse or create appropriate predicates and functions to accurately express the logic of the action. Individual conditions in preconditions and effects should be listed separately. Each predicate/function in PDDL must have a unique name, and its parameters must be explicitly defined in the predicate/function definition. Make sure all names are intuitive, readable, and consistent with the domain context.

To guide your generation, you will be shown two examples from the same domain:
1. Format Example: Demonstrates the expected structure and formatting. Please follow this format strictly.
2. Similar Action Example: Provides a reference that is semantically close to your task. You may draw inspiration from it, but do not copy. Instead, generate your output based on the given action description and domain description.\n"""

        cot_example_headers = list(re.finditer(r'Example\s+(\d+). ', similar_domain_prompt_cot_example))
        ############ if it has only one action example:
        if len(cot_example_headers) == 1:
            format_example_idx = 0
            similar_example_idx = 0
 
        else:

            if similar_action_idx == 0:
                format_example_idx = 1
                similar_example_idx = 0
            else:
                format_example_idx = similar_action_idx - 1
                similar_example_idx = similar_action_idx

        cot_format_example = self.parse_best_example_with_cot_no_header(cot_example_headers, similar_domain_prompt_cot_example, format_example_idx)
        cot_similar_example = self.parse_best_example_with_cot_no_header(cot_example_headers, similar_domain_prompt_cot_example, similar_example_idx)

        example_headers = list(re.finditer(r'Example\s+(\d+). ', similar_domain_prompt_example))
        similar_output_PDDL_format_example = self.parse_llm_output_format(example_headers, similar_domain_prompt_example, format_example_idx)
        cot_header_format_example = self.parse_action_desc_fluent_list(example_headers, similar_domain_prompt_example, format_example_idx)
        similar_output_PDDL_similar_example = self.parse_llm_output_format(example_headers, similar_domain_prompt_example, similar_example_idx)
        cot_header_similar_example = self.parse_action_desc_fluent_list(example_headers, similar_domain_prompt_example, similar_example_idx)

        template += f"""
Example domain information: {similar_domain_desc} 

Format Example: {cot_header_format_example} """
        
        template += cot_format_example + "\n\n"

        template += similar_output_PDDL_format_example + "\n\n"


        template += f"""
Similar Action Example: {cot_header_similar_example} """
        
        template += cot_similar_example + "\n\n"

        template += similar_output_PDDL_similar_example + "\n\n"

        template += self.task_generate_instruction()


        return template

        






    def top1_2_best_cot_prompt(self, top1_domain_cot_example, top2_domain_cot_example
                        , top1_domain_prompt_example, top2_domain_prompt_example
                        , top1_similar_action_idx, top2_similar_action_idx
                        , top1_similar_domain_desc, top2_similar_domain_desc):
        """
        two top 1, 2 COT examples for reference, examples are from different domains
        """
        template = """
You are given a domain description and an action description. Your task is to define the preconditions and effects of this action using PDDL format. You should either reuse or create appropriate predicates and functions to accurately express the logic of the action. Individual conditions in preconditions and effects should be listed separately. Each predicate/function in PDDL must have a unique name, and its parameters must be explicitly defined in the predicate/function definition. Make sure all names are intuitive, readable, and consistent with the domain context.

To guide your generation, you will be shown two examples from two domains. They both provide references that are semantically close to your task. You may draw inspiration from them, but do not copy. Instead, generate your output based on the given action description and domain description. Your output should also strictly follow the example.\n"""

        top1_cot_example_headers = list(re.finditer(r'Example\s+(\d+). ', top1_domain_cot_example))
        top1_similar_example = self.parse_best_example_with_cot_no_header(top1_cot_example_headers, top1_domain_cot_example, top1_similar_action_idx)

        top2_cot_example_headers = list(re.finditer(r'Example\s+(\d+). ', top2_domain_cot_example))
        top2_similar_example = self.parse_best_example_with_cot_no_header(top2_cot_example_headers, top2_domain_cot_example, top2_similar_action_idx)

        top1_example_headers = list(re.finditer(r'Example\s+(\d+). ', top1_domain_prompt_example))
        top1_similar_output_PDDL_example = self.parse_llm_output_format(top1_example_headers, top1_domain_prompt_example, top1_similar_action_idx)
        top1_cot_header_example = self.parse_action_desc_fluent_list(top1_example_headers, top1_domain_prompt_example, top1_similar_action_idx)

        top2_example_headers = list(re.finditer(r'Example\s+(\d+). ', top2_domain_prompt_example))
        top2_similar_output_PDDL_example = self.parse_llm_output_format(top2_example_headers, top2_domain_prompt_example, top2_similar_action_idx)
        top2_cot_header_example = self.parse_action_desc_fluent_list(top2_example_headers, top2_domain_prompt_example, top2_similar_action_idx)

        template += f"""
Example 1 domain information: {top1_similar_domain_desc} """
        
        template += "\n\n"

        template += "Example 1: " + top1_cot_header_example

        template += top1_similar_example + "\n\n"

        template += top1_similar_output_PDDL_example

        template += "\n"


        template += f"""
Example 2 domain information: {top2_similar_domain_desc} """
        
        template += "\n\n"

        template += "Example 2: " + top2_cot_header_example

        template += "\n\n" + top2_similar_example + "\n\n"

        template += top2_similar_output_PDDL_example

        template += "\n\n"

        template += self.task_generate_instruction()
        
        return template




    
    def two_step_cot_best_prompt(self, similar_domain_prompt_cot_example
                        , similar_action_idx
                        , similar_domain_desc):
        """
        two step COT best prompt using one best cot example
        first step: COT guide to answer the problem
        second step: PDDL action generation
        """
        pass



def llm_reranker_prompt(query, candidates, idx):
    idx_map = {i+1: idx for i, idx in enumerate(idx)}
    numbered = "\n".join([f"{i+1}. {sent}" for i, sent in enumerate(candidates)])
    prompt = f"""You are a helpful AI assistant that ranks candidate sentences by their semantic similarity to a given query.

Query:
"{query}"

Candidates:
{numbered}

Please rank the candidates from most to least semantically similar to the query.
Only return a list of the numbers in ranked order (e.g., "3, 1, 2, ..."), without any explanation.
If you think all the candidates are irrelevant in any case, ONLY return -1 as the output.
"""
    return prompt, idx_map




def generate_abs_action_desc_prompt(action_desc):

    template = f"""
You are a language abstraction assistant. Your task is to generate a generalized description for the PDDL action description by abstracting the concrete entities.

Follow these instructions:

INSTRUCTIONS:
1. Preserve verbs, and all words related to `uav`, `rover`, `truck`, `robot arm` or `ugv`.
2. Remove any concrete names, states, adjectives (like `location`, `image`, `component`, `clear`, `connected`) and replace them with `[variableX]`, where X is a number.
3. Omit any examples, especially phrases like "For example, ..." and anything that follows.

NAMING RULES:
- Use `[variable1]`, `[variable2]`, etc. to represent abstracted entities.
- Reuse variable numbers where appropriate across the same sentence for semantic consistency.

EXAMPLES:

Input:
This action enables the uav to fly from its current location to another location that is directly connected. The uav must be in the air to fly. For example, the uav is in the air and can fly from position_1 to position_2 if they are connected.

Output:
This action enables the uav to fly from [variable1] to [variable2] if [variable1] and [variable2] are [variable3] and if the uav is in [variable4].

Input:
This action enables the uav to mark the current location as a valid landing spot, if the uav is in the air and if the location is clear. For example, the uav flies to check position_1, if position_1 is clear, then position_1 is marked as valid landing spot.

Output:
This action enables the uav to mark [variable1] as [variable2] if the uav is in [variable3] and [variable1] is [variable4].

Now process the following input in the same way:
{action_desc}
"""
        
    return template











# if __name__ == "__main__":
#     pg = TemplateGenerator("top1_2_best_cot")
#     domain_path1 = "uav_domain_benchmark\Perching"
#     with open(os.path.join(domain_path1, "domain_desc.txt"), 'r', encoding='utf-8') as f:
#         top1_domain_desc = f.read().strip()
#     with open(os.path.join(domain_path1, "domain_example_prompt.txt"), 'r', encoding='utf-8') as f:
#         top1_domain_example_prompt = f.read().strip()
#     with open(os.path.join(domain_path1, "cot_prompt.txt"), 'r', encoding='utf-8') as f:
#         top1_domain_cot_example_prompt = f.read().strip()

    

#     domain_path2 = "uav_domain_benchmark\Watering"
#     with open(os.path.join(domain_path2, "domain_desc.txt"), 'r', encoding='utf-8') as f:
#         top2_domain_desc1 = f.read().strip()
#     with open(os.path.join(domain_path2, "domain_example_prompt.txt"), 'r', encoding='utf-8') as f:
#         top2_domain_example_prompt1 = f.read().strip()
#     with open(os.path.join(domain_path2, "cot_prompt.txt"), 'r', encoding='utf-8') as f:
#         top2_domain_cot_example_prompt1 = f.read().strip()

#     prompt = pg.generate_prompt(       top1_domain_example_prompt, top2_domain_example_prompt1,
#                                         2, 1,
#                                         top1_domain_desc, top2_domain_desc1,
#                                         top1_domain_cot_example_prompt, top2_domain_cot_example_prompt1)
    

#     print(prompt)
