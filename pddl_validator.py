from copy import deepcopy
import re
from utils.pddl_output_utils import parse_param_output, parse_new_predicates, parse_predicates, parse_new_functions, parse_functions, read_object_types


class PDDL_Validator:
    def __init__(self, obj_hierarchy_info,
                 error_types=None, messed_output_len=20, unsupported_keywords=None):
        self.default_error_types = ['messed_output_len',
                               'unsupported_keywords',
                               'invalid_param_types',
                               'invalid_predicate_format',
                               'invalid_function_format',
                               'invalid_predicate_name',
                               'invalid_function_names',
                               'invalid_predicate_usage',
                               'invalid_function_usage',
                               'invalid_numeric_usage']
        default_unsupported = ['forall', 'when', 'exists', 'implies']
        self.keywords = ['forall', 'when', 'exists', 'implies']
        self.error_types = self.default_error_types if error_types is None else error_types
        self.unsupported_keywords = unsupported_keywords if unsupported_keywords else default_unsupported
        self.messed_output_len = messed_output_len
        self.obj_types = read_object_types(obj_hierarchy_info)
        self.obj_hierarchy_info = obj_hierarchy_info

        ##### need to reset for every validation #####
    
        self.error_types_return_count_dict = {'has_unsupported_keywords': 0,
                               'messed_output_feedback': 0,
                               'invalid_object_type': 0,
                               'invalid_predicate_names': 0,
                               'invalid_predicate_format': 0,
                               'invalid_predicate_usage': 0,
                               'invalid_fluents_usage': 0,
                               'invalid_function_names': 0,
                               'invalid_function_format': 0,
                               'invalid_function_usage': 0,
                               'invalid_numeric_usage': 0}
    
    def error_type_reset(self):
        """
        Reset the error type counts to zero.
        """
        for error_type in self.error_types_return_count_dict:
            self.error_types_return_count_dict[error_type] = 0

    def update_error_type_count(self, error_type):
        """
        Update the count of a specific error type.
        """
        if error_type in self.error_types_return_count_dict:
            self.error_types_return_count_dict[error_type] += 1
        else:
            raise ValueError(f"Error type '{error_type}' is not recognized.")
    

    def perform_validation(self, llm_output, **kwargs):
        for error_type in self.error_types:
            if error_type == 'messed_output_len':
                validation_info = self.check_messed_output(llm_output, **kwargs)
            elif error_type == 'unsupported_keywords':
                validation_info = self.check_unsupported_keywords(llm_output, **kwargs)
            elif error_type == 'invalid_param_types':
                validation_info = self.check_param_types(llm_output, **kwargs)
            elif error_type == 'invalid_predicate_name':
                validation_info = self.check_predicate_names(llm_output, **kwargs)
            elif error_type == 'invalid_predicate_format':
                validation_info = self.check_predicate_format(llm_output, **kwargs)
            elif error_type == 'invalid_predicate_usage':
                validation_info = self.check_predicate_usage(llm_output, **kwargs)
            elif error_type == 'invalid_function_names':
                validation_info = self.check_function_names(llm_output, **kwargs)
            elif error_type == 'invalid_function_format':
                validation_info = self.check_functions_format(llm_output, **kwargs)
            elif error_type == 'invalid_function_usage':
                validation_info = self.check_function_usage(llm_output, **kwargs)
            elif error_type == 'invalid_numeric_usage':
                validation_info = self.check_nested_numeric_logic(llm_output, **kwargs)
            else:
                raise NotImplementedError
            if not validation_info[0]:
                return validation_info
        return True, 'all_validation_pass', None, None
    

    def check_unsupported_keywords(self, llm_output, **kwargs):
        """
        A simple function to check whether the pddl model uses unsupported logic keywords
        """
        for keyword in self.unsupported_keywords:
            if f'({keyword} ' in llm_output:
                feedback_message = f'The precondition or effect contain the keyword `{keyword}` that is not supported in our PDDL model format. Please express the same logic in a simplified way. You can come up with new predicates or new functions if needed (but note that you should use existing predicates and functions as much as possible). '
                return False, 'has_unsupported_keywords', keyword, feedback_message
        return True, 'has_unsupported_keywords', None, None

    def check_messed_output(self, llm_output, **kwargs):
        """
        Though this happens extremely rarely, the LLM (even GPT-4) might generate messed-up outputs (basically
            listing a large number of predicates in preconditions and effects)
        """
        #assert '\nPreconditions:' in llm_output, llm_output
        if '\nPreconditions:' not in llm_output or '\nEffects:' not in llm_output:
            feedback_message = 'The output must strictlly follow the example format and contain the required sections: "Parameters", "Preconditions", "Effects", "New Predicates" and "New Functions". Please ensure that the output PDDL model is complete and includes these sections. '
            return False, 'messed_output_feedback', None, feedback_message
        
        precond_str = llm_output.split('\nPreconditions:')[1].split('```')[1].strip()
        if len(precond_str.split('\n')) > self.messed_output_len:
            feedback_message = f'You seem to have generated an action model with an unusually long list of preconditions. Please include only the relevant preconditions/effects and keep the action model concise. '
            return False, 'messed_output_feedback', None, feedback_message

        return True, 'messed_output_feedback', None, None

    def check_param_types(self, llm_output, **kwargs):
        params_info = parse_param_output(llm_output)
        for param_name in params_info:
            param_type = params_info[param_name]
            if param_type not in self.obj_types:
                print(self.obj_types)
                feedback_message = f'There is an invalid object type `{param_type}` for the parameter {param_name}. Please revise the PDDL model to fix this error. '
                return False, 'invalid_object_type', param_name, feedback_message
        return True, 'invalid_object_type', None, None

    def check_predicate_names(self, llm_output, **kwargs):
        curr_predicates = kwargs['curr_predicates']
        curr_pred_names = {pred['name'].lower(): pred for pred in curr_predicates}
        new_predicates = parse_new_predicates(llm_output)

        # check name clash with obj types
        invalid_preds = list()
        for new_pred in new_predicates:
            curr_obj_types = {t.lower() for t in self.obj_types}
            if new_pred['name'].lower() in curr_obj_types:
                invalid_preds.append(new_pred['name'])
        if len(invalid_preds) > 0:
            feedback_message = f'The following predicate(s) have the same name(s) as existing object types:'
            for pred_i, pred_name in enumerate(list(invalid_preds)):
                feedback_message += f'\n{pred_i + 1}. {pred_name}'
            feedback_message += '\nPlease rename these predicates. '
            return False, 'invalid_predicate_names', None, feedback_message

        # check name clash with existing predicates
        duplicated_predicates = list()
        for new_pred in new_predicates:
            if new_pred['name'].lower() in curr_pred_names:
                duplicated_predicates.append((new_pred['raw'], curr_pred_names[new_pred['name'].lower()]['raw']))
        if len(duplicated_predicates) > 0:
            feedback_message = f'The following predicate(s) have the same name(s) as existing predicate(s):'
            for pred_i, duplicated_pred_info in enumerate(duplicated_predicates):
                new_pred_full, existing_pred_full = duplicated_pred_info
                feedback_message += f'\n{pred_i + 1}. {new_pred_full.replace(":", ",")}; existing predicate with the same name: {existing_pred_full.replace(":", ",")}'
            feedback_message += '\n\nYou should reuse existing predicates whenever possible. If you are reusing existing predicate(s), you shouldn\'t list them under \'New Predicates\'. If existing predicates are not enough and you are devising new predicate(s), please use names that are different from existing ones.'
            feedback_message += '\n\nPlease revise the PDDL model to fix this error.\n\n'
            
            return False, 'invalid_predicate_names', None, feedback_message

        return True, 'invalid_predicate_names', None, None

    def check_predicate_format(self, llm_output, **kwargs):
        """
        Though this happens rarely, the LLM (even GPT-4) might forget to define the object type of some parameters in new predicates
        """
        new_predicates = parse_new_predicates(llm_output)
        for new_pred in new_predicates:
            new_pred_def = new_pred['raw'].split(': ')[0]
            new_pred_def = new_pred_def[1:-1].strip()   # discard the parentheses
            split_predicate = new_pred_def.split(' ')[1:]   # discard the predicate name
            split_predicate = [e for e in split_predicate if e != '']

            for i, p in enumerate(split_predicate):
                if i % 3 == 0:
                    if '?' not in p:
                        feedback_message = f'There are syntax errors in the definition of the new predicate {new_pred_def}. Please revise its definition and output the entire PDDL action model again. Note that you need to strictly follow the syntax of PDDL. '
                        return False, 'invalid_predicate_format', None, feedback_message
                    else:
                        if i + 1 >= len(split_predicate) or split_predicate[i+1] != '-':
                            feedback_message = f'There are syntax errors in the definition of the new predicate {new_pred_def}. Please revise its definition and output the entire PDDL action model again. Note that you need to define the object type of each parameter and strictly follow the syntax of PDDL. '
                            return False, 'invalid_predicate_format', None, feedback_message
                        if i + 2 >= len(split_predicate):
                            feedback_message = f'There are syntax errors in the definition of the new predicate {new_pred_def}. Please revise its definition and output the entire PDDL action model again. Note that you need to define the object type of each parameter and strictly follow the syntax of PDDL. '
                            return False, 'invalid_predicate_format', None, feedback_message
                        param_obj_type = split_predicate[i+2]
                        if param_obj_type not in self.obj_types:
                            feedback_message = f'There is an invalid object type `{param_obj_type}` for the parameter {p} in the definition of the new predicate {new_pred_def}. Please revise its definition and output the entire PDDL action model again. '
                            return False, 'invalid_predicate_format', None, feedback_message
        return True, 'invalid_predicate_format', None, None

    def _is_valid_type(self, target_type, curr_type):
        if target_type == curr_type:
            return True
        if target_type not in self.obj_hierarchy_info or len(self.obj_hierarchy_info[target_type]) == 0:
            return False
        else:
            for subtype in self.obj_hierarchy_info[target_type]:
                if self._is_valid_type(subtype, curr_type):
                    return True
            return False

    def _check_predicate_usage_pddl(self, pddl_snippet, predicate_list, function_list, action_params, part='preconditions'):
        """
        This function checks three types of errors:
            - check if the num of params given matches the num of params in predicate definition
            - check if there is any param that is not listed under `Parameters:`
            - check if the param type matches that in the predicate definition
        """
        def get_ordinal_suffix(_num):
            return {1: 'st', 2: 'nd', 3: 'rd'}.get(_num % 10, 'th') if _num not in (11, 12, 13) else 'th'

        pred_names = {predicate_list[i]['name']: i for i in range(len(predicate_list))}
        pddl_elems = [e for e in pddl_snippet.split(' ') if e != '']

        function_names = {function_list[i]['name']: i for i in range(len(function_list))}

        operator_name = ['and', 'not', 'increase', 'decrease', 'assign', '<', '>', '<=', '>=', '=', '+', '-']

        idx = 0
        while idx < len(pddl_elems):
            if pddl_elems[idx] == '(' and idx + 1 < len(pddl_elems):
                if pddl_elems[idx + 1] in pred_names:
                    curr_pred_name = pddl_elems[idx + 1]
                    curr_pred_params = list()
                    target_pred_info = predicate_list[pred_names[curr_pred_name]]
                    # read params
                    idx += 2
                    while idx < len(pddl_elems) and pddl_elems[idx] != ')':
                        curr_pred_params.append(pddl_elems[idx])
                        idx += 1
                    # check if the num of params are correct
                    n_expected_param = len(target_pred_info['params'])
                    if n_expected_param != len(curr_pred_params):
                        feedback_message = f'In the {part}, the predicate `{curr_pred_name}` requires {n_expected_param} parameters but {len(curr_pred_params)} parameters were provided. Please revise the PDDL model to fix this error. '
                        return False, 'invalid_predicate_usage', None, feedback_message
                    # check if there is any unknown param
                    for curr_param in curr_pred_params:
                        if curr_param not in action_params:
                            feedback_message = f'In the {part} and in the predicate `{curr_pred_name}`, there is an unknown parameter {curr_param}. You should define all parameters (i.e., name and type) under the `Parameters` list. Please revise the PDDL model to fix this error (and other potentially similar errors). '
                            return False, 'invalid_predicate_usage', None, feedback_message
                    # check if the object types are correct
                    target_param_types = [target_pred_info['params'][t_p] for t_p in target_pred_info['params']]
                    for param_idx, target_type in enumerate(target_param_types):
                        curr_param = curr_pred_params[param_idx]
                        claimed_type = action_params[curr_param]

                        if not self._is_valid_type(target_type, claimed_type):
                            feedback_message = f'There is a syntax error in the {part.lower()}, the {param_idx+1}-{get_ordinal_suffix(param_idx+1)} parameter of `{curr_pred_name}` should be a `{target_type}` but a `{claimed_type}` was given. Please use the correct predicate or devise new one(s) if needed (but note that you should use existing predicates as much as possible). '
                            return False, 'invalid_predicate_usage', None, feedback_message

                elif pddl_elems[idx + 1] not in operator_name and pddl_elems[idx + 1] not in function_names:
                    feedback_message = f'In the {part}, there is a syntax error: `{pddl_elems[idx + 1]}` is not defined. Please revise the PDDL model to fix this error. Note that you can always create new predicates and functions, but you should also use the existing predicates and functions as much as possible. '
                    return False, 'invalid_fluents_usage', None, feedback_message
            
            idx += 1
        return True, 'invalid_predicate_usage', None, None

    def check_predicate_usage(self, llm_output, **kwargs):
        """
        This function performs very basic check over whether the predicates are used in a valid way.
            This check should be performed at the end.
        """
        # parse predicates
        new_predicates = parse_new_predicates(llm_output)
        curr_predicates = deepcopy(kwargs['curr_predicates'])
        curr_predicates.extend(new_predicates)
        curr_predicates = parse_predicates(curr_predicates)

        # parse functions
        new_functions = parse_new_functions(llm_output)
        curr_functions = deepcopy(kwargs.get('curr_functions', []))
        curr_functions.extend(new_functions)
        curr_functions = parse_functions(curr_functions)


        # get action params
        params_info = parse_param_output(llm_output)

        # check preconditions
        precond_str = llm_output.split('\nPreconditions:')[1].split('```')[1].strip()
        precond_str = precond_str.replace('\n', ' ').replace('(', ' ( ').replace(')', ' ) ')
        validation_info = self._check_predicate_usage_pddl(precond_str, curr_predicates, curr_functions, params_info, part='preconditions')
        if not validation_info[0]:
            return validation_info

        eff_str = llm_output.split('\nEffects:')[1].split('```')[1].strip()
        eff_str = eff_str.replace('\n', ' ').replace('(', ' ( ').replace(')', ' ) ')
        return self._check_predicate_usage_pddl(eff_str, curr_predicates, curr_functions, params_info, part='effects')




    ################################################
    ################################################
    ################################################
    ################################################
    # check functions usage
    def check_function_names(self, llm_output, **kwargs):
        """
        Check whether new functions have name conflicts with object types, existing predicates, or existing functions.
        """
        curr_predicates = kwargs.get('curr_predicates', [])
        curr_functions = kwargs.get('curr_functions', [])
        
        curr_pred_names = {pred['name'].lower(): pred for pred in curr_predicates}
        curr_func_names = {func['name'].lower(): func for func in curr_functions}

        new_functions = parse_new_functions(llm_output)

        # 0. Check misuse of PDDL keywords as new functions
        forbidden_keywords = {"increase", "decrease", "assign","+","-","<=",">=","<",">","="}
        keyword_misused = [f['name'] for f in new_functions if f['name'].lower() in forbidden_keywords]
        if keyword_misused:
            feedback_message = f"The following reserved PDDL numerical keywords are seen as functions:"
            for i, kw in enumerate(keyword_misused):
                feedback_message += f"\n{i + 1}. {kw}"
            feedback_message += "\nThese are PDDL numerical keywords instead of functions."
            feedback_message += "\nPlease remove these entries from New Functions list. "
            return False, 'invalid_function_names', None, feedback_message

        # check name clash with obj types
        invalid_funcs = []
        curr_obj_types = {t.lower() for t in self.obj_types}
        for new_func in new_functions:
            if new_func['name'].lower() in curr_obj_types:
                invalid_funcs.append(new_func['name'])
        if len(invalid_funcs) > 0:
            feedback_message = f'The following function(s) have the same name(s) as existing object types:'
            for func_i, func_name in enumerate(invalid_funcs):
                feedback_message += f'\n{func_i + 1}. {func_name}'
            feedback_message += '\nPlease rename these functions. '
            return False, 'invalid_function_names', None, feedback_message

        # check name clash with existing predicates
        duplicated_with_predicates = []
        for new_func in new_functions:
            if new_func['name'].lower() in curr_pred_names:
                duplicated_with_predicates.append((new_func['raw'], curr_pred_names[new_func['name'].lower()]['raw']))
        if len(duplicated_with_predicates) > 0:
            feedback_message = f'The following function(s) have the same name(s) as existing predicate(s):'
            for func_i, duplicated_info in enumerate(duplicated_with_predicates):
                new_func_full, existing_pred_full = duplicated_info
                feedback_message += f'\n{func_i + 1}. {new_func_full.replace(":", ",")}; existing predicate: {existing_pred_full.replace(":", ",")}'
            feedback_message += '\n\nYou should rename the function(s) to avoid confusion with predicates. '
            return False, 'invalid_function_names', None, feedback_message

        # check name clash with existing functions
        duplicated_with_functions = []
        for new_func in new_functions:
            if new_func['name'].lower() in curr_func_names:
                duplicated_with_functions.append((new_func['raw'], curr_func_names[new_func['name'].lower()]['raw']))
        if len(duplicated_with_functions) > 0:
            feedback_message = f'The following function(s) have the same name(s) as existing function(s):'
            for func_i, duplicated_info in enumerate(duplicated_with_functions):
                new_func_full, existing_func_full = duplicated_info
                feedback_message += f'\n{func_i + 1}. {new_func_full.replace(":", ",")}; existing function: {existing_func_full.replace(":", ",")}'
            feedback_message += '\n\nIf you are reusing existing functions, you should not list them under "New Functions". Otherwise, please use a different name. '
            return False, 'invalid_function_names', None, feedback_message

        return True, 'invalid_function_names', None, None




    def check_functions_format(self, llm_output, **kwargs):
        """
        Check if the format of function definitions is correct.
        Similar to predicate format checking: (function-name ?param - type ...)
        """
        new_functions = parse_new_functions(llm_output)
        for new_func in new_functions:
            new_func_def = new_func['raw'].split(': ')[0]   # only take raw def (drop any comment)
            new_func_def = new_func_def[1:-1].strip()        # remove outer parentheses
            split_function = new_func_def.split(' ')[1:]     # skip the function name
            split_function = [e for e in split_function if e != '']

            for i, p in enumerate(split_function):
                if i % 3 == 0:
                    if not p.startswith('?'):
                        feedback_message = f'There are syntax errors in the definition of the new function {new_func_def}. Each parameter must start with "?". Please revise its definition and output the entire PDDL action model again. '
                        return False, 'invalid_function_format', None, feedback_message
                    else:
                        if i + 1 >= len(split_function) or split_function[i+1] != '-':
                            feedback_message = f'There are syntax errors in the definition of the new function {new_func_def}. Missing "-" and the type after `{p}`. Please revise its definition and output the entire PDDL action model again. '
                            return False, 'invalid_function_format', None, feedback_message
                        if i + 2 >= len(split_function):
                            feedback_message = f'There are syntax errors in the definition of the new function {new_func_def}. Missing type after `{p}`. Please revise its definition and output the entire PDDL action model again. '
                            return False, 'invalid_function_format', None, feedback_message
                        param_obj_type = split_function[i+2]
                        if param_obj_type not in self.obj_types:
                            feedback_message = f'There is an invalid object type `{param_obj_type}` for the parameter `{p}` in the function {new_func_def}. Please revise its definition and output the entire PDDL action model again. '
                            return False, 'invalid_function_format', None, feedback_message
        return True, 'invalid_function_format', None, None




    def _check_function_usage_pddl(self, pddl_snippet, function_list, action_params, part='preconditions'):
        """
        This function checks:
            - if the number of params given matches the number of params in function definition
            - if each param is a valid defined action parameter
            - if param types match the function's expected parameter types
        """
        def get_ordinal_suffix(_num):
            return {1: 'st', 2: 'nd', 3: 'rd'}.get(_num % 10, 'th') if _num not in (11, 12, 13) else 'th'

        func_names = {function_list[i]['name']: i for i in range(len(function_list))}
        pddl_elems = [e for e in pddl_snippet.split(' ') if e != '']
        idx = 0
        while idx < len(pddl_elems):
            if pddl_elems[idx] == '(' and idx + 1 < len(pddl_elems):
                if pddl_elems[idx + 1] in func_names:
                    curr_func_name = pddl_elems[idx + 1]
                    curr_func_params = list()
                    target_func_info = function_list[func_names[curr_func_name]]
                    # read params
                    idx += 2
                    while idx < len(pddl_elems) and pddl_elems[idx] != ')':
                        curr_func_params.append(pddl_elems[idx])
                        idx += 1
                    # check number of parameters
                    n_expected_param = len(target_func_info['params'])
                    if n_expected_param != len(curr_func_params):
                        feedback_message = f'In the {part}, the function `{curr_func_name}` requires {n_expected_param} parameters but {len(curr_func_params)} were provided. Please revise the PDDL model to fix this error. '
                        return False, 'invalid_function_usage', None, feedback_message
                    # check unknown parameters
                    for curr_param in curr_func_params:
                        if curr_param not in action_params:
                            feedback_message = f'In the {part} and in the function `{curr_func_name}`, there is an unknown parameter `{curr_param}`. You should define all parameters (i.e., name and type) under the `Parameters` list.'
                            feedback_message += f' Please revise the PDDL model to fix this error (and other potentially similar errors). '
                            return False, 'invalid_function_usage', None, feedback_message
                    # check parameter types
                    target_param_types = [target_func_info['params'][t_p] for t_p in target_func_info['params']]
                    for param_idx, target_type in enumerate(target_param_types):
                        curr_param = curr_func_params[param_idx]
                        claimed_type = action_params[curr_param]
                        if not self._is_valid_type(target_type, claimed_type):
                            feedback_message = f'There is a type mismatch in the {part.lower()}, the {param_idx+1}{get_ordinal_suffix(param_idx+1)} parameter of `{curr_func_name}` should be a `{target_type}` but a `{claimed_type}` was given.'
                            feedback_message += f' Please use the correct function or devise new one(s) if needed (but note that you should use existing functions as much as possible). '
                            return False, 'invalid_function_usage', None, feedback_message
            idx += 1
        return True, 'invalid_function_usage', None, None



    def check_function_usage(self, llm_output, **kwargs):
        """
        Check whether the functions are used correctly in the action's preconditions and effects.
        """
        # parse functions
        new_functions = parse_new_functions(llm_output)
        curr_functions = deepcopy(kwargs.get('curr_functions', []))
        curr_functions.extend(new_functions)
        curr_functions = parse_functions(curr_functions)

        # get action params
        params_info = parse_param_output(llm_output)

        # check preconditions
        precond_str = llm_output.split('\nPreconditions:')[1].split('```')[1].strip()
        precond_str = precond_str.replace('\n', ' ').replace('(', ' ( ').replace(')', ' ) ')
        validation_info = self._check_function_usage_pddl(precond_str, curr_functions, params_info, part='preconditions')
        if not validation_info[0]:
            return validation_info

        # check effects
        eff_str = llm_output.split('\nEffects:')[1].split('```')[1].strip()
        eff_str = eff_str.replace('\n', ' ').replace('(', ' ( ').replace(')', ' ) ')
        return self._check_function_usage_pddl(eff_str, curr_functions, params_info, part='effects')




    #####################################################
    #####################################################
    ######################################################

    # need to  add: keywords: increase, decrease, assign should not be seen as functions
    # check the composition of keywords

    # check Numerical keywords for functions
    # the supported keywords are: increase, decrease, assign, <=, >=


    def check_nested_numeric_logic(self, llm_output, **kwargs):
        """
        Check nested expressions involving +, -, increase, decrease, <=, >=, <, > in both Preconditions and Effects.
        """

        def parse_tokens_to_tree(tokens):
            stack = []
            current = []
            for tok in tokens:
                if tok == '(':
                    stack.append(current)
                    current = []
                elif tok == ')':
                    if not stack:
                        raise ValueError("Unbalanced parentheses in expression, please check if the parentheses are closed properly.")
                    parent = stack.pop()
                    parent.append(current)
                    current = parent
                else:
                    current.append(tok)
            if stack:
                raise ValueError("Unbalanced parentheses at end of expression, please check if the parentheses are closed properly.")
            return current[0] if current else []

        def check_tree(expr_tree, context, func_names, pred_names):
            if not isinstance(expr_tree, list) or len(expr_tree) == 0:
                return False, "invalid_numeric_usage", None, f"Malformed expression in `{context}` block. Please revise to fix this error.  "

            head = expr_tree[0]
            args = expr_tree[1:]

            if head in ['>=', '<=', '<', '>']:
                if context != 'Preconditions':
                    return False, "invalid_numeric_usage", None, f"Comparator `{head}` is only allowed in Preconditions. Please revise to fix this error.  "
                if len(args) != 2:
                    return False, "invalid_numeric_usage", None, f"Comparator `{head}` in `{context}` must have exactly two arguments. Please revise to fix this error.  "

                for i, arg in enumerate(args):
                    if isinstance(arg, list):
                        ok, key, info, msg = check_tree(arg, context, func_names, pred_names)
                        if not ok:
                            return False, key, info, msg
                    else:
                        if arg in pred_names:
                            return False, "invalid_numeric_usage", None, f"In the `{context}` block and `{head}` expression, argument {i+1} `{arg}` is a predicate. Please revise to fix this error, note that you can always create new functions, but you should also use the existing functions as much as possible.  "
                        if i == 0 and arg not in func_names:
                            return False, "invalid_numeric_usage", None, f"In the `{context}` block and `{head}` expression, the first argument `{arg}` must be a defined function. Please revise to fix this error, note that you can always create new functions, but you should also use the existing functions as much as possible. "
                        if i == 1 and arg not in func_names:
                            try:
                                float(arg)
                            except ValueError:
                                return False, "invalid_numeric_usage", None, f"In the `{context}` block and `{head}` expression, the second argument `{arg}` must be a numeric function or constant. Please revise to fix this error, note that you can always create new functions, but you should also use the existing functions as much as possible. "

            elif head in ['+', '-']:
                if len(args) != 2:
                    return False, "invalid_numeric_usage", None, f"Arithmetic operator `{head}` in `{context}` must have exactly 2 arguments. Please revise to fix this error. "
                for i, arg in enumerate(args):
                    if isinstance(arg, list):
                        ok, key, info, msg = check_tree(arg, context, func_names, pred_names)
                        if not ok:
                            return False, key, info, msg
                    else:
                        if arg in pred_names:
                            return False, "invalid_numeric_usage", None, f"In `{context}` block and `{head}` expression, argument {i+1} `{arg}` is a predicate but should be a function or constant. Please revise to fix this error, note that you can always create new functions, but you should also use the existing functions as much as possible. "
                        if arg not in func_names:
                            try:
                                float(arg)
                            except ValueError:
                                return False, "invalid_numeric_usage", None, f"In `{context}` block and `{head}` expression, argument {i+1} `{arg}` is not a numeric function or constant. Please revise to fix this error, note that you can always create new functions, but you should also use the existing functions as much as possible. "

            elif head in ['increase', 'decrease']:
                if context != 'Effects':
                    return False, "invalid_numeric_usage", None, f"Operator `{head}` is only allowed in Effects. Please revise to fix this error. "
                if len(args) != 2:
                    return False, "invalid_numeric_usage", None, f"Operator `{head}` in `{context}` must have exactly 2 arguments. Please revise to fix this error. "

                arg1 = args[0]
                if isinstance(arg1, list):
                    ok, key, info, msg = check_tree(arg1, context, func_names, pred_names)
                    if not ok:
                        return False, key, info, msg
                else:
                    if arg1 in pred_names:
                        return False, "invalid_numeric_usage", None, f"In the `{context}` block and `{head}` expression, the first argument `{arg1}` is a predicate but should be a function. Please revise to fix this error, note that you can always create new functions, but you should also use the existing functions as much as possible. "
                    if arg1 not in func_names:
                        return False, "invalid_numeric_usage", None, f"In the `{context}` block and `{head}` expression, the first argument `{arg1}` is not a defined function. Please revise to fix this error, note that you can always create new functions, but you should also use the existing functions as much as possible. "

                arg2 = args[1]
                if isinstance(arg2, list):
                    ok, key, info, msg = check_tree(arg2, context, func_names, pred_names)
                    if not ok:
                        return False, key, info, msg
                else:
                    if arg2 in pred_names:
                        return False, "invalid_numeric_usage", None, f"In the `{context}` block and `{head}` expression, the second argument `{arg2}` is a predicate but should be a numeric function or value. Please revise to fix this error, note that you can always create new functions, but you should also use the existing functions as much as possible. "
                    if arg2 not in func_names:
                        try:
                            float(arg2)
                        except ValueError:
                            return False, "invalid_numeric_usage", None, f"In the `{context}` block and `{head}` expression, the second argument `{arg2}` is not a numeric constant or function. Please revise to fix this error, note that you can always create new functions, but you should also use the existing functions as much as possible. "

            else:
                if head in pred_names:
                    return False, "invalid_numeric_usage", None, f"Head `{head}` in `{context}` is a predicate but should be a function. Please revise to fix this error, note that you can always create new functions, but you should also use the existing functions as much as possible. "
                # if head not in func_names:
                #     return False, "invalid_numeric_usage", None, f"Function `{head}` in `{context}` is not defined. Please revise to fix this error, note that you can always create new functions, but you should also use the existing functions as much as possible. "

            return True, None, None, None
    
        def contains_numeric_keywords(tokens):
            numeric_keywords = {'+', '-', '>=', '<=', '<', '>', 'increase', 'decrease'}
            return any(tok in numeric_keywords for tok in tokens)

        from copy import deepcopy

        curr_functions = kwargs.get('curr_functions', [])
        new_functions = parse_new_functions(llm_output)
        all_functions = deepcopy(curr_functions)
        all_functions.extend(new_functions)
        func_names = {func['name'] for func in all_functions}

        curr_predicates = kwargs.get('curr_predicates', [])
        new_predicates = parse_new_predicates(llm_output)
        all_predicates = deepcopy(curr_predicates)
        all_predicates.extend(new_predicates)
        #print(all_predicates)
        #all_predicates = parse_predicates(all_predicates)
        pred_names = {pred['name'] for pred in all_predicates}

        for block_type in ["Preconditions", "Effects"]:
            try:
                block = llm_output.split(f'\n{block_type}:')[1].split('```')[1].strip()
            except Exception:
                return False, "invalid_numeric_usage", None, f"Failed to parse {block_type} block.  "

            lines = block.split('\n')
            for line in lines:
                line = line.strip()
                if not line or line == "(and":
                    continue
                tokens = [t for t in line.replace('(', ' ( ').replace(')', ' ) ').split() if t]
                if not contains_numeric_keywords(tokens):
                    continue
                try:
                    tree = parse_tokens_to_tree(tokens)
                except ValueError:
                    return False, "invalid_numeric_usage", None, f"Unbalanced parentheses in expression `{line}` in `{block_type}`.  "
                ok, key, info, msg = check_tree(tree, block_type, func_names, pred_names)
                if not ok:
                    return False, key, info, msg

        return True, None, None, None



 ########### need to fix: functions don't have to have arguments





def main():


    kwargs = {
        'curr_predicates': list(),
        'curr_functions': list()
    }
    obj_hierarchy = {
        "uav": [],
        "position": []
    }
    pddl_snippet = """
    
1. ?u - uav: the UAV  
2. ?p - position: the current position of the UAV
3. ?goal - position: the goal position

Preconditions:
```
(and
    (at ?u ?p)
    (= ?p ?goal)
)
```

Effects:
```
(and
    (task-finished ?u)
    (increase (cost ?u) 1)
)
```

New Predicates:
1. (task-finished ?u - uav): true if the UAV ?u has completed the task by reaching the goal position

New Functions:
No newly defined function
    """

# New Predicates:(Please write: "No newly defined predicate" below if there is no new predicate)
    # precond_str = snap1.split('\nPreconditions:')[1].split('```')[1]
    # precond_str = precond_str.replace('\n', ' ').replace('(', ' ( ').replace(')', ' ) ')
    # print(precond_str)
    pddl_validator = PDDL_Validator(obj_hierarchy)
    print(pddl_validator.check_messed_output(pddl_snippet, **kwargs))
    print(pddl_validator.check_param_types(pddl_snippet, **kwargs))
    print(pddl_validator.check_predicate_format(pddl_snippet, **kwargs))
    print(pddl_validator.check_functions_format(pddl_snippet, **kwargs))
    print(pddl_validator.check_predicate_names(pddl_snippet, **kwargs))
    print(pddl_validator.check_function_names(pddl_snippet, **kwargs))

    print(pddl_validator.check_predicate_usage(pddl_snippet, **kwargs))
    print(pddl_validator.check_function_usage(pddl_snippet, **kwargs))
    print(pddl_validator.check_nested_numeric_logic(pddl_snippet, **kwargs))


if __name__ == '__main__':
    main()
