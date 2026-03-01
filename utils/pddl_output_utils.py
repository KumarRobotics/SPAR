from collections import OrderedDict
from copy import deepcopy

from addict import Dict
import re
import json

def parse_param_output(llm_output):
    params_info = OrderedDict()
    params_str = llm_output.split('\nPreconditions:')[0].strip().split('\n\n')[-1]
    for line in params_str.split('\n'):
        if line.strip() == '' or '.' not in line:
            continue
        if not line.split('.')[0].strip().isdigit():
            continue
        try:
            p_info = [e for e in line.split(':')[0].split(' ') if e != '']
            param_name, param_type = p_info[1].strip(), p_info[3].strip()
            params_info[param_name] = param_type
        except Exception:
            print(f'[WARNING] checking param object types - fail to parse: {line}')
            continue
    return params_info


def parse_new_predicates(llm_output):
    new_predicates = []
    pattern1 = r'New Predicates:\s*'
    pattern2 = r'New Predicates:\(Please write: "No newly defined predicate" below if there is no new predicate\)\s*'

    match1 = re.search(pattern1, llm_output)
    match2 = re.search(pattern2, llm_output)

    header1_start_idx = match1.start() if match1 else -1
    header2_start_idx = match2.start() if match2 else -1
    # print(f'[DEBUG] header1_start_idx: {header1_start_idx}, header2_start_idx: {header2_start_idx}')

    if header1_start_idx >= 0 and header2_start_idx < 0: ########### llm output the header 1
        start_idx = header1_start_idx
        header = llm_output[match1.start():match1.end()]
        if 'No newly defined predicate' in llm_output:
            return new_predicates
    
    elif header2_start_idx >= 0 and header1_start_idx >= 0: ########### llm output the header 2
        start_idx = header2_start_idx
        header = llm_output[match2.start():match2.end()]
        front_idx = llm_output.find("No newly defined predicate")
        end_idx = llm_output.rfind("No newly defined predicate")  ### hard code....:  if there exist the second one, must be no new predicate
        if front_idx >= 0 and end_idx >= 0 and front_idx != end_idx:
            return new_predicates  # return empty list if no new predicate found
        
    else: ########### llm output wrong header
        ### throw an error
        raise ValueError('No valid header found in the LLM output for new predicate.')


    predicate_output = llm_output[start_idx + len(header):].strip().split('\n\n')[0].strip()

    for p_line in predicate_output.split('\n'):
        if '.' not in p_line or not p_line.split('.')[0].strip().isdigit():
            print(f'[WARNING] unable to parse the line: {p_line}')
            continue

        try:
            raw_line = p_line.split('. ', 1)[1].strip()  # e.g. "(at ?r - rob ?p - pos): UAV is at position"
            predicate_desc = raw_line.split(': ', 1)[1].strip()
            raw_predicate = raw_line  # raw includes signature + desc
            signature = raw_line.split(':', 1)[0].strip()
        except IndexError:
            print(f'[WARNING] missing description: {p_line}')
            continue

        # Extract name from signature
        if signature.startswith('(') and signature.endswith(')'):
            predicate_name = signature[1:-1].split(' ')[0]
        else:
            predicate_name = signature.lstrip('(').rstrip(')').split(' ')[0]

        new_predicates.append({
            'name': predicate_name,
            'desc': predicate_desc,
            'raw': raw_predicate
        })

    return new_predicates


def parse_predicates(all_predicates):
    """
    This function assumes the predicate definitions adhere to PDDL grammar
    """
    all_predicates = deepcopy(all_predicates)
    for i, pred in enumerate(all_predicates):
        if 'params' in pred:
            continue
        pred_def = pred['raw'].split(': ')[0]
        pred_def = pred_def[1:-1].strip()  # discard the parentheses
        split_predicate = pred_def.split(' ')[1:]   # discard the predicate name
        split_predicate = [e for e in split_predicate if e != '']

        pred['params'] = OrderedDict()
        for j, p in enumerate(split_predicate):
            if j % 3 == 0:
                assert '?' in p, f'invalid predicate definition: {pred_def}'
                assert split_predicate[j+1] == '-', f'invalid predicate definition: {pred_def}'
                param_name, param_obj_type = p, split_predicate[j+2]
                pred['params'][param_name] = param_obj_type
    return all_predicates



def parse_new_functions(llm_output):
    new_functions = []
    pattern1 = r'New Functions:\s*'
    pattern2 = r'New Functions:\(Please write: "No newly defined function" below if there is no new function\)\s*'

    match1 = re.search(pattern1, llm_output)
    match2 = re.search(pattern2, llm_output)

    header1_start_idx = match1.start() if match1 else -1
    header2_start_idx = match2.start() if match2 else -1
    #print(f'[DEBUG] header1_start_idx: {header1_start_idx}, header2_start_idx: {header2_start_idx}')

    if header1_start_idx >= 0 and header2_start_idx < 0: ########### llm output the header 1
        start_idx = header1_start_idx
        header = llm_output[match1.start():match1.end()]
        if 'No newly defined function' in llm_output:
            return new_functions
    
    elif header2_start_idx >= 0 and header1_start_idx >= 0: ########### llm output the header 2
        start_idx = header2_start_idx
        header = llm_output[match2.start():match2.end()]
        front_idx = llm_output.find("No newly defined function")
        end_idx = llm_output.rfind("No newly defined function")  ### hard code....:  if there exist the second one, must be no new function
        if front_idx >= 0 and end_idx >= 0 and front_idx != end_idx:
            return new_functions  # return empty list if no new function found
    
    elif header1_start_idx < 0 and header2_start_idx < 0: ########### llm output no header
        return new_functions

    else: ########### llm output wrong header
        ### throw an error
        raise ValueError('No valid header found in the LLM output for new function.')

    function_output = llm_output[start_idx + len(header):].strip().split('\n\n')[0].strip()

    for f_line in function_output.split('\n'):
        if '.' not in f_line or not f_line.split('.')[0].strip().isdigit():
            print(f'[WARNING] unable to parse the line: {f_line}')
            continue

        try:
            function_desc = f_line.split(': ')[1].strip()
        except IndexError:
            print(f'[WARNING] missing description: {f_line}')
            continue

        # Extract function name
        try:
            raw_function = f_line.split('. ', 1)[1]  # e.g. "(battery-level ?u - uav): The remaining battery..."
            signature = raw_function.split(':', 1)[0].strip()
            if signature.startswith('(') and signature.endswith(')'):
                function_name = signature[1:-1].split(' ')[0]
            else:
                function_name = signature.lstrip('(').rstrip(')').split(' ')[0]
        except Exception as e:
            print(f'[ERROR] failed to extract function name: {f_line} ({e})')
            continue

        new_functions.append({
            'name': function_name,
            'desc': function_desc,
            'raw': raw_function.strip()
        })

    return new_functions

def parse_functions(all_functions):
    """
    This function assumes the function definitions adhere to PDDL grammar
    """
    all_functions = deepcopy(all_functions)
    for i, func in enumerate(all_functions):
        if 'params' in func:
            continue
        func_def = func['raw'].split(': ')[0]
        func_def = func_def[1:-1].strip()  # discard the parentheses
        split_function = func_def.split(' ')[1:]   # discard the function name
        split_function = [e for e in split_function if e != '']

        func['params'] = OrderedDict()
        for j, p in enumerate(split_function):
            if j % 3 == 0:
                assert '?' in p, f'invalid function definition: {func_def}'
                assert split_function[j+1] == '-', f'invalid function definition: {func_def}'
                param_name, param_obj_type = p, split_function[j+2]
                func['params'][param_name] = param_obj_type
    return all_functions





def read_object_types(hierarchy_info):
    obj_types = set()
    for obj_type in hierarchy_info:
        obj_types.add(obj_type)
        if len(hierarchy_info[obj_type]) > 0:
            obj_types.update(hierarchy_info[obj_type])
    return obj_types


def flatten_pddl_output(pddl_str):
    open_parentheses = 0
    old_count = 0
    flat_str = ''
    pddl_lines = pddl_str.strip().split('\n')
    for line_i, pddl_line in enumerate(pddl_lines):
        pddl_line = pddl_line.strip()
        # process parentheses
        for char in pddl_line:
            if char == '(':
                open_parentheses += 1
            elif char == ')':
                open_parentheses -= 1
        if line_i == 0:
            flat_str += pddl_line + '\n'
        elif line_i == len(pddl_lines) - 1:
            flat_str += pddl_line
        else:
            assert open_parentheses >= 1, f'{open_parentheses}'
            leading_space = ' ' if old_count > 1 else '  '
            if open_parentheses == 1:
                flat_str += leading_space + pddl_line + '\n'
            else:
                flat_str += leading_space + pddl_line
        old_count = open_parentheses
    return flat_str


def parse_full_domain_model(llm_output_dict, action_info):
    def find_leftmost_dot(string):
        for i, char in enumerate(string):
            if char == '.':
                return i
        return 0

    parsed_action_info = Dict()
    for act_name in action_info:
        if act_name in llm_output_dict:
            llm_output = llm_output_dict[act_name]['llm_output']
            try:
                # the first part is parameters
                parsed_action_info[act_name]['parameters'] = list()
                params_str = llm_output.split('\nPreconditions:')[0].strip().split('\n\n')[-1]
                for line in params_str.split('\n'):
                    if line.strip() == '' or '.' not in line:
                        continue
                    if not line.split('.')[0].strip().isdigit():
                        continue
                    leftmost_dot_idx = find_leftmost_dot(line)
                    param_line = line[leftmost_dot_idx + 1:].strip()
                    parsed_action_info[act_name]['parameters'].append(param_line)
                # the second part is preconditions
                parsed_action_info[act_name]['preconditions'] = flatten_pddl_output(llm_output.split('Preconditions:')[1].split('```')[1].strip())
                # the third part is effects
                parsed_action_info[act_name]['effects'] = flatten_pddl_output(llm_output.split('Effects:')[1].split('```')[1].strip())
                # include the act description
                parsed_action_info[act_name]['action_desc'] = llm_output_dict[act_name]['action_desc'] if 'action_desc' in llm_output_dict[act_name] else ''
            except:
                print('[ERROR] errors in parsing pddl output')
                # print(llm_output)
    return parsed_action_info



"""
extract a action block from a PDDL domain file
"""
def extract_action_block(pddl_text, action_name):
    pattern = rf"\(:action\s+{re.escape(action_name)}\b"
    match = re.search(pattern, pddl_text)
    if not match:
        return None

    start = match.start()
    open_parens = 0

    for i in range(start, len(pddl_text)):
        if pddl_text[i] == '(':
            open_parens += 1
        elif pddl_text[i] == ')':
            open_parens -= 1
            if open_parens == 0:
                return pddl_text[start:i+1]
    
    return None



###############   get the pddl domain from the llm output #################
import re


def extract_action_from_pddl_output(text):

    # 使用正则提取 Parameters 到 Effects 的块
    pattern = re.compile(
        r"Parameters:(.*?)Effects:\s*```(.*?)```",
        re.DOTALL
    )

    matches = pattern.findall(text)

    # 整理成清晰格式输出
    extracted_blocks = []
    for params_block, effects_block in matches:
        combined = f"Parameters:\n{params_block.strip()}\n\nEffects:```\n{effects_block.strip()}\n```"
        extracted_blocks.append(combined)

    return extracted_blocks



def format_to_pddl_action_block(action_name: str, text: str) -> str:
    """
    Parse 'Parameters', 'Preconditions', and 'Effects' from structured text and
    format into a PDDL action block.
    """
    # Extract parameters section
    param_match = re.search(r'Parameters:\s*(.*?)\n(?:Preconditions|Effects):', text, re.DOTALL)
    parameters = []
    if param_match:
        param_lines = param_match.group(1).strip().splitlines()
        for line in param_lines:
            # Match lines like: "1. ?r - robot: the robot"
            match = re.match(r'\d+\.\s*(\?\w+)\s*-\s*(\w+)', line)
            if match:
                var, type_ = match.groups()
                parameters.append(f"{var} - {type_}")

    # Extract preconditions block
    precond_match = re.search(r'Preconditions:\s*```(?:[^\n]*)\n(.*?)```', text, re.DOTALL)
    preconditions = precond_match.group(1).strip() if precond_match else ""

    # Extract last effects block
    effect_match = re.search(r'Effects:\s*```(?:[^\n]*)\n(.*?)```', text, re.DOTALL)
    effects = effect_match.group(1).strip() if effect_match else ""

    # Construct PDDL action block

    if "and" not in preconditions:
        preconditions = f"(and\n" + preconditions + "\n)"
    
    if "and" not in effects:
        effects = f"(and\n" + effects + "\n)"

    pddl = f"""(:action {action_name}
 :parameters ({' '.join(parameters)})
 :precondition {preconditions}
 :effect {effects}
)"""
    return pddl


def parse_predicates_and_functions(predicates, functions):
    """
    Parse predicates and functions from PDDL files.
    """
    predicates = re.sub(r':', ';', predicates)
    functions = re.sub(r':', ';', functions)

    if functions.strip() == "":
        pddl = f"""
(:predicates
{predicates}
)"""
        return pddl

    pddl = f"""
(:predicates
{predicates}
)

(:functions
{functions}
)
"""
    return pddl

def parse_requirement_and_type(hierarchy_info):
    
    types = hierarchy_info['hierarchy']
    requirements = hierarchy_info['requirements']

    requirements_str = ''
    for requirement in requirements:
        requirements_str += f':{requirement}'.strip() + ' '
    requirements = requirements_str.strip()

    types_str = ''
    for obj_type in types.keys():
        types_str += f'{obj_type}'.strip() + '\n'
    types_str = types_str.strip()

    pddl = f"""
(:requirements {requirements_str} )

(:types
{types_str}
)
    """
    return pddl


def parse_pddl_domain_from_llm_output(hierarchy_requirements_file,
                                      predicates_file,
                                      functions_file,
                                      action_output_file):
    domain_str = '(define (domain test_domain)\n'

    domain_str += parse_requirement_and_type(hierarchy_requirements_file)
    domain_str += '\n'
    domain_str += parse_predicates_and_functions(predicates_file, functions_file)
    domain_str += '\n'
    

    action_names = re.findall(r'Action Name in PDDL:\s*(.+)', action_output_file)

    action_blocks = extract_action_from_pddl_output(action_output_file)

    for i, action_name in enumerate(action_names):

        action_block = format_to_pddl_action_block( action_name , action_blocks[i])
        domain_str += '\n' + action_block + '\n'

    domain_str += ')'

    return domain_str


if __name__ == '__main__':
    # with open(r'uav_domain_benchmark\2DNavigation\hierarchy_requirements.json', 'r', encoding='utf-8') as f:
    #     hierarchy_requirements_file = json.load(f)
    # with open(r'results\2025-07-04-18-57\gpt-4\basic_best\CeilingPaint\gpt-4_basic_best_predicates.txt', 'r', encoding='utf-8') as f:
    #     predicates_file = f.read().strip()
    # with open(r'results\2025-07-04-18-57\gpt-4\basic_best\CeilingPaint\gpt-4_basic_best_functions.txt', 'r', encoding='utf-8') as f:
    #     functions_file = f.read().strip()
    # with open(r'results\2025-07-04-18-57\gpt-4\basic_best\CeilingPaint\gpt-4_0_1.txt', 'r', encoding='utf-8') as f:
    #     action_output_file = f.read().strip()

    # domain_str = parse_pddl_domain_from_llm_output(
    #     hierarchy_requirements_file,
    #     predicates_file,
    #     functions_file,
    #     action_output_file)

    # print(domain_str)

    action_output_file = """Parameters:
1. ?u - uav: The uav  

Preconditions:
```
(and 
    (has-current-angle ?u) 
    (not (less-than-current-angle ?u))
)
```

Effects:
```
    (has-new-angle ?u)
```

New Predicates:(Please write: "No newly defined predicate" below if there is no new predicate)
No newly defined predicate

New Functions:(Please write: "No newly defined function" below if there is no new function)
No newly defined function
"""

    action_blocks = extract_action_from_pddl_output(action_output_file)
    print(len(action_blocks))

    action_block = format_to_pddl_action_block( "pass-gate" , action_blocks[0])

    print(action_block)
