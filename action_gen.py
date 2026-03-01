import json
import os
from copy import deepcopy
from datetime import datetime

from addict import Dict

from utils.pddl_output_utils import parse_new_predicates, parse_new_functions, parse_pddl_domain_from_llm_output
from pddl_validator import PDDL_Validator
from prompts.template_generator import TemplateGenerator

best_example_record = {}

def get_predicate_prompt(predicate_list):
    predicate_prompt = 'You can create and define new predicates, but you may also reuse the following predicates:'
    if len(predicate_list) == 0:
        predicate_prompt += '\nNo predicate has been defined yet'
    else:
        for i, p in enumerate(predicate_list):
            predicate_prompt += f'\n{i+1}. {p["raw"]}'
    return predicate_prompt


def get_function_prompt(function_list):
    function_prompt = 'You can create and define new functions, but you may also reuse the following functions:'
    if len(function_list) == 0:
        function_prompt += '\nNo function has been defined yet'
    else:
        for i, p in enumerate(function_list):
            function_prompt += f'\n{i+1}. {p["raw"]}'
    return function_prompt


def get_action_prompt(prompt_template, action_desc, include_extra_info):
    action_desc_prompt = action_desc['desc']
    if include_extra_info:
        for feedback_i in action_desc['extra_info']:
            action_desc_prompt += ' ' + feedback_i
    if '{action_desc}' in prompt_template:
        full_prompt = prompt_template.replace('{action_desc}', action_desc_prompt)
    # full_prompt = str(prompt_template) + ' ' + action_desc_prompt
    return full_prompt, action_desc_prompt


def construct_action_model(llm_conn, action_predicate_function_prompt,
                           action_name, predicate_list, function_list, max_iteration=8,
                           shorten_message=False, syntax_validator=None):
    def _shorten_message(_msg, _step_i):
        """
        Only keep the latest LLM output and correction feedback
        """
        print(f'[INFO] step: {_step_i} | num of messages: {len(_msg)}')
        if _step_i == 1:
            return [_msg[0]]
        else:
            _short_msg = [_msg[0], _msg[2 * (_step_i - 1) - 1], _msg[2 * (_step_i - 1)]]
            assert _short_msg[1]['role'] == 'assistant'
            assert _short_msg[2]['role'] == 'user'
            return _short_msg

    results_dict = Dict({action_name: Dict()})

    conn_success, llm_output = False, ''
    no_syntax_error = False
    messages = [{'role': 'user', 'content': action_predicate_function_prompt}]
    i_iter = 0
    while not no_syntax_error and i_iter < max_iteration:
        i_iter += 1
        print(f'[INFO] generating PDDL of action: `{action_name}` | # of messages: {len(messages)}')
        llm_message = _shorten_message(messages, i_iter) if shorten_message else messages
        conn_success, llm_output = llm_conn.get_response(prompt=None, messages=llm_message)
        messages.append({'role': 'assistant', 'content': llm_output})
        if not conn_success:
            raise Exception('Fail to connect to the LLM')
        results_dict[action_name][f'iter_{i_iter}']['llm_output'] = llm_output
        results_dict[action_name]['llm_output'] = llm_output
        
        print(llm_output)

        if syntax_validator is not None:
            val_kwargs = {'curr_predicates': predicate_list, 'curr_functions': function_list}
            validation_info = syntax_validator.perform_validation(llm_output, **val_kwargs)
            if not validation_info[0]:
                error_type, feedback_msg = validation_info[1], validation_info[3]
                syntax_validator.update_error_type_count(error_type) #### count the error type
                print('-' * 20)
                print(f'[INFO] feedback message on {error_type}:')

                feedback_msg += f'\nPlease correct the above error and try again. Note that the output should strictly follow the example format. DO NOT output any additional information(such as any explanation, notes or thoughts).\n\nParameters:'
                print(feedback_msg)
                
                results_dict[action_name][f'iter_{i_iter}']['error_type'] = error_type
                results_dict[action_name][f'iter_{i_iter}']['feedback_msg'] = feedback_msg
                messages.append({'role': 'user', 'content': feedback_msg})
                print('-' * 20)
                continue
        no_syntax_error = True

    if not no_syntax_error:
        print(f'[WARNING] syntax error remaining in the action model: {action_name}')
    # update the predicate and function list
    new_predicates = parse_new_predicates(llm_output)
    new_functions = parse_new_functions(llm_output)

    predicate_list.extend(new_predicates)
    function_list.extend(new_functions)

    results_dict[action_name]['new_predicates'] = [new_p['raw'] for new_p in new_predicates]
    results_dict[action_name]['new_functions'] = [new_f['raw'] for new_f in new_functions]

    return llm_output, results_dict, predicate_list, function_list



def update_prompt_template(template_generator, method, current_domain=None, 
                           action=None, action_desc=None,
                           llm_gpt=None, action_lib_path=None, lm_method='minilm'):

        """
        Generate a prompt based on the method and provided descriptions.
        """

        current_action_query = action_desc[action]['desc']
        current_abs_action_query = action_desc[action]['abstract_desc']

        if method == "basic_blockworld":
            return template_generator.basic_blockworld_prompt()
        elif method == "basic_best":

            best_result = llm_gpt.find_best_action_domain(
                query=current_abs_action_query,
                current_domain_name=current_domain,
                action_lib_embed_path=action_lib_path,
                llm_method=lm_method,
                top_k=20,
                fine_with_llm=True, 
                nl_query=current_action_query
            )
            
            top1_domain_prompt_example = best_result['example_prompt'][0]
            top1_domain_desc = best_result['domain_desc'][0]
            top1_similar_action_idx = best_result['action_idx'][0]
            best_example_record[current_action_query] = "\n" + best_result['action_nl_desc'][0]

            return template_generator.basic_best_prompt(top1_domain_prompt_example, top1_similar_action_idx, top1_domain_desc)
        
        
        elif method == "basic_cot":
            return template_generator.basic_cot_prompt()
        
        elif method == "basic_cot_best":

            best_result = llm_gpt.find_best_action_domain(
                query=current_abs_action_query,
                current_domain_name=current_domain,
                action_lib_embed_path=action_lib_path,
                llm_method=lm_method,
                top_k=20,
                fine_with_llm=True, 
                nl_query=current_action_query
            )
            
            top1_domain_prompt_example = best_result['example_prompt'][0]
            top1_domain_desc = best_result['domain_desc'][0]
            top1_similar_action_idx = best_result['action_idx'][0]
            top1_similar_domain_prompt_cot_example = best_result['cot_prompt'][0]
            best_example_record[current_action_query] = "\n" + best_result['action_nl_desc'][0]

            return template_generator.basic_cot_best_prompt(
                                                top1_similar_domain_prompt_cot_example, 
                                                top1_domain_prompt_example, 
                                                top1_similar_action_idx, 
                                                top1_domain_desc)
        
        else:
            raise ValueError(f"Unknown method: {method}")


def start_words(prompt_method):
    """
    Return the start words for the prompt based on the method.
    """
    if prompt_method == 'basic_blockworld':
        return '\n\nParameters:'
    elif prompt_method == 'basic_best':
        return '\n\nParameters:'
    elif prompt_method == 'two_consist_best':
        return '\n\nParameters:'
    elif prompt_method == 'top1_2_best':
        return '\n\nParameters:'
    elif prompt_method == 'basic_cot':
        return '\n\nLet \'s think step by step and answers the following questions. Your output should be strictly following this format:'
    elif prompt_method == 'basic_cot_best':
        return '\n\nLet \'s think step by step and answers the following questions. Your output should be strictly following this format:'
    elif prompt_method == 'consist_best_cot':
        return '\n\nLet \'s think step by step and answers the following questions. Your output should be strictly following this format:'
    elif prompt_method == 'top1_2_best_cot':
        return '\n\nLet \'s think step by step and answers the following questions. Your output should be strictly following this format:'
    else:
        raise ValueError(f"Unknown prompt method: {prompt_method}")











def action_generator(_domain_name_str='CeilingPaint',
                      _engine='gpt-4.1-nano-2025-04-14', 
                      _prompt_method='basic_blockworld',
                      _result_log_dir = None):
    actions = None  # None means all actions
    include_additional_info = True
    domain = _domain_name_str  
    engine = _engine  
    lm_method = 'minilm'  # 'ada' or 'minilm', the method to find the best action domain
    unsupported_keywords = ['forall', 'when', 'exists', 'implies', 'or']
    max_iterations = 2  
    max_feedback = 10  
    shorten_messages = False 
    action_lib_path = 'prompts\cached_action_embeddings_openai.npz' if lm_method == 'ada' else "prompts\cached_action_embeddings_minilm.npz" # the path to the action library embedding file


    ################  prompt template | read the domain input  ################
    prompt_method = _prompt_method  # 'basic_blockworld', 'basic_best', 'two_consist_best', 'top1_2_best', 'basic_cot', 'basic_cot_best', 'consist_best_cot', 'top1_2_best_cot'
    template_generator = TemplateGenerator(prompt_method)

    domain_data_dir = f'uav_domain_benchmark/{domain}/'
    with open(os.path.join(domain_data_dir, f'domain_desc.txt')) as f:
        domain_desc_str = f.read().strip()
    with open(os.path.join(domain_data_dir, f'action_desc.json')) as f:
        action_desc = json.load(f)
    with open(os.path.join(domain_data_dir, f'hierarchy_requirements.json')) as f:
        type_requirements = json.load(f)
        obj_hierarchy_info = type_requirements['hierarchy']


    #######################  syntax validator ####################
    syntax_validator = PDDL_Validator(obj_hierarchy_info, unsupported_keywords=unsupported_keywords)
    syntax_validator.error_type_reset()  # reset the error types counts to default
    type_set = ', '.join(syntax_validator.obj_types)

    ################ init LLM ####################
    from llm_model import GPT_Chat
    llm_gpt = GPT_Chat(engine=engine)

    ################ init param ####################
    if actions is None:
        actions = list(action_desc.keys())
        actions_name_in_pddl = [action_desc[action]['name_in_pddl'] for action in actions]


    predicate_list = list()
    function_list = list()
    results_dict = Dict()

    ################# action by action generation #################
    for i_iter in range(max_iterations):
        readable_results = ''
        prev_predicate_list = deepcopy(predicate_list)
        prev_function_list = deepcopy(function_list)

        for i_action, action in enumerate(actions):
            

            ################ must update the template generator for each action ################
            ################ different prompt methods have different prompt templates and params ################
            prompt_template = update_prompt_template(template_generator, prompt_method, domain
                                                     , action, action_desc, llm_gpt, action_lib_path
                                                     , lm_method=lm_method)

            if '{domain_desc}' in prompt_template:
                    prompt_template = prompt_template.replace('{domain_desc}', domain_desc_str)
            if '{types}' in prompt_template:
                prompt_template = prompt_template.replace('{types}', str(type_set))

            action_prompt, action_desc_prompt = get_action_prompt(prompt_template, action_desc[action],
                                                                  include_additional_info)

            print('\n')
            print('#' * 20)
            print(f'[INFO] iter {i_iter} | action {i_action}: {action}.')
            print('#' * 20)
            readable_results += '\n' * 2 + '#' * 20 + '\n' + f'Action: {action}\n' + '#' * 20 + '\n'
            readable_results += '\n' + f'Action Name in PDDL: {actions_name_in_pddl[i_action]}\n' + '#' * 20 + '\n'

            predicate_prompt = get_predicate_prompt(predicate_list)
            function_prompt = get_function_prompt(function_list)

            results_dict[action]['predicate_prompt'] = predicate_prompt
            results_dict[action]['function_prompt'] = function_prompt
            results_dict[action]['action_desc'] = action_desc_prompt
            readable_results += '-' * 20
            readable_results += f'\n{predicate_prompt}\n' + '-' * 20
            readable_results += f'\n{function_prompt}\n' + '-' * 20

            action_predicate_function_prompt = f'{action_prompt}\n\n{predicate_prompt}\n\n{function_prompt}'
            
            ############ different prompt methods have different start words ############
            action_predicate_function_prompt += start_words(prompt_method)  

            #print(action_predicate_function_prompt)


            pddl_construction_output = construct_action_model(llm_gpt, action_predicate_function_prompt, action, predicate_list, function_list,
                                                              shorten_message=shorten_messages, max_iteration=max_feedback,
                                                              syntax_validator=syntax_validator)
            llm_output, action_results_dict, predicate_list, function_list = pddl_construction_output

            results_dict.update(action_results_dict)
            readable_results += '\n' + '-' * 10 + '-' * 10 + '\n'
            readable_results += "\nParameters:\n"
            readable_results += llm_output + '\n'

        readable_results += '\n' + '-' * 10 + '-' * 10 + '\n'
        readable_results += 'Extracted predicates:\n'
        for i, p in enumerate(predicate_list):
            readable_results += f'\n{i + 1}. {p["raw"]}'

        readable_results += '\n' + '-' * 10 + '-' * 10 + '\n'
        readable_results += 'Extracted functions:\n'
        for i, p in enumerate(function_list):
            readable_results += f'\n{i + 1}. {p["raw"]}'

        with open(os.path.join(_result_log_dir, f'{engine}_0_{i_iter}.txt'), 'w') as f:
            f.write(readable_results)
        with open(os.path.join(_result_log_dir, f'{engine}_0_{i_iter}.json'), 'w') as f:
            json.dump(results_dict, f, indent=4, sort_keys=False)

        gen_done = False
        if len(prev_predicate_list) == len(predicate_list) and len(prev_function_list) == len(function_list):
            print(f'[INFO] iter {i_iter} | no new predicate and new function has been defined, will terminate the process')
            gen_done = True

        if gen_done:
            break

    # save the predicates
    predicate_list_str = ''
    for idx, predicate in enumerate(predicate_list):
        if idx == 0:
            predicate_list_str += predicate['raw']
        else:
            predicate_list_str += '\n' + predicate['raw']
    with open(os.path.join(_result_log_dir, f'{engine}_{prompt_method}_predicates.txt'), 'w') as f:
        f.write(predicate_list_str)

    # save the functions
    function_list_str = ''
    for idx, function in enumerate(function_list):
        if idx == 0:
            function_list_str += function['raw']
        else:
            function_list_str += '\n' + function['raw']
    with open(os.path.join(_result_log_dir, f'{engine}_{prompt_method}_functions.txt'), 'w') as f:
        f.write(function_list_str)


    ### save the total error types count
    with open(os.path.join(_result_log_dir, f'{engine}_{prompt_method}_error_count.json'), "w", encoding="utf-8") as f:
        json.dump(syntax_validator.error_types_return_count_dict, f, indent=4, ensure_ascii=False)

    ### save the generated pddl domain
    pddl_domain_str = parse_pddl_domain_from_llm_output(type_requirements, 
                                                        predicate_list_str,
                                                        function_list_str,
                                                        readable_results)
    with open(os.path.join(_result_log_dir, f'{engine}_{prompt_method}_domain.pddl'), 'w') as f:
        f.write(pddl_domain_str)

    #### save the best example record
    if prompt_method == 'basic_best' or prompt_method == 'basic_cot_best':
        with open(os.path.join(_result_log_dir, f'{engine}_{prompt_method}_best_example_record.json'), 'w') as f:
            json.dump(best_example_record, f, indent=4, ensure_ascii=False)

        best_example_record.clear()  # clear the record for the next run


    return syntax_validator.error_types_return_count_dict

if __name__ == '__main__':

    _domain_name_str = 'Watering'
    _engine = 'gpt-4.1-mini-2025-04-14'   # 'deepseek-chat'  'gpt-4.1-mini-2025-04-14'


    # 1. basic example : basic_blockworld
    # 2. basic example with cot : basic_cot
    # 3. 1 basic example + 1 similar example : basic_best
    # 4. 1 basic example with cot + similar example with cot : basic_cot_best

    _prompt_method = 'basic_cot_best'

    _result_log_dir = f'temp_result/{_engine}/{_prompt_method}/{_domain_name_str}/'
    os.makedirs(_result_log_dir, exist_ok=True)

    action_generator(_domain_name_str, 
                     _engine, 
                     _prompt_method,
                     _result_log_dir)
