#####################   evaluation of a PDDL domain's comlexity level #############

import re
from collections import defaultdict

import re
from collections import defaultdict
from typing import List, Dict
import json
import math
import os
import numpy as np


# Default weights, can be adjusted based on requirements
default_weights = {
    "num_predicates": 0.25,
    "num_functions": 0.3,
    "num_actions": 0.25,
    "num_types": 0.15,
    "interdependency_score": 0.35,
    "action_coupling_score": 0.35,
    "avg_preconditions": 0.2,
    "avg_effects": 0.2
}


#### requirement weights: consider the following supported requirements
requirement_weights = {
    ":strips": 0,
    ":typing": 0,
    ":negative_preconditions": 0,
    ":equality": 0,
    ":fluents": 0,
    ":numerical_fluents": 0
}


class PDDLDomainComplexity:
    def __init__(self, weights=None):
        self.domain_name = ""
        self.requirements = []
        self.types = []
        self.predicates = {}   
        self.functions = {}  
        self.actions = []

        self.predicate_names = set()
        self.function_names = set()

        if weights is None:
            self.weights = default_weights  # Use default weights if none provided
        else:
            self.weights = weights  # Weights for different complexity components

    def reset(self):
        self.domain_name = ""
        self.requirements = []
        self.types = []
        self.predicates = {}
        self.functions = {}
        self.actions = []

        self.predicate_names.clear()
        self.function_names.clear()

    def _tokenize(self, text):
        text = re.sub(r";.*", "", text)
        return re.findall(r'[()]|[^\s()]+', text)

    def _parse_sexpr(self, tokens):
        stack, current = [], []
        for token in tokens:
            if token == '(':
                stack.append(current)
                current = []
            elif token == ')':
                if not stack:
                    raise SyntaxError("Unmatched closing parenthesis")
                last = stack.pop()
                last.append(current)
                current = last
            else:
                current.append(token)
        if stack:
            raise SyntaxError("Unmatched opening parenthesis")
        return current[0]

    def parse(self, domain_str): #################### parse a PDDL domain except for actions
        tokens = self._tokenize(domain_str)
        parsed = self._parse_sexpr(tokens)

        if parsed[0] != 'define':
            raise ValueError("Not a valid PDDL domain file")

        for section in parsed[1:]:
            head = section[0]
            if head == 'domain':
                self.domain_name = section[1]
            elif head == ':requirements':
                self.requirements = section[1:]
            elif head == ':types':
                self.types = section[1:]
            elif head == ':predicates':
                for pred in section[1:]:
                    name = pred[0]
                    self.predicates[name] = pred[1:]
                    self.predicate_names.add(name)
            elif head == ':functions':
                for func in section[1:]:
                    name = func[0]
                    self.functions[name] = func[1:]
                    self.function_names.add(name)
            elif head == ':action':
                self.actions.append(self._parse_action(section))


    def _parse_action(self, action_block):   #### parse action block
        action = {'name': action_block[1], 'parameters': [], 'preconditions': [], 'effects': []}
        block_iter = iter(action_block[2:])
        for part in block_iter:
            if part == ':parameters':
                parameters = next(block_iter)
                action['parameters'] = parameters
            elif part == ':precondition':
                precondition = next(block_iter)
                action['preconditions'] = precondition
            elif part == ':effect':
                effect = next(block_iter)
                action['effects'] = effect
        return action


    def compute_complexity(self):
        
        predicate_usage = defaultdict(set)
        function_usage = defaultdict(set)
        action_effects = {}
        action_preconds = {}
        action_precond_list = {}
        action_effect_list = {}

        def iterate_expr(expr, a_name, add_set, add_list):
            stack = [expr]
            while stack:
                current = stack.pop()
                if not isinstance(current, list) or not current:
                    continue
                head = current[0]
                if head in self.predicate_names:
                    predicate_usage[head].add(a_name)
                    add_set.add(head)
                    add_list.append(head)
                elif head in self.function_names:
                    function_usage[head].add(a_name)
                    add_set.add(head)
                    add_list.append(head)
                else:
                    for item in current:
                        if isinstance(item, list):
                            stack.append(item)


        for action in self.actions:
            a_name = action['name']
            action_effects[a_name] = set()
            action_preconds[a_name] = set()
            action_precond_list[a_name] = []
            action_effect_list[a_name] = []

            for expr in action['preconditions']:
                iterate_expr(expr, a_name, action_preconds[a_name], action_precond_list[a_name])

            for expr in action['effects']:
                iterate_expr(expr, a_name, action_effects[a_name], action_effect_list[a_name])


        # Interdependency score: how many actions share predicates/functions
        pred_interdep = sum(len(v) for v in predicate_usage.values()) / (len(self.predicates) or 1)
        func_interdep = sum(len(v) for v in function_usage.values()) / (len(self.functions) or 1)
        interdependency_score = pred_interdep + 2.5 * func_interdep

        # Coupling score: one action’s effects appearing in another’s preconditions
        coupling_score = 0
        for a1 in self.actions:
            a1_name = a1['name']
            effects = action_effects[a1_name]
            for a2 in self.actions:
                if a1 == a2:
                    continue
                for expr in action_preconds[a2['name']]:
                    flat_expr = str(expr)
                    if any(eff in flat_expr for eff in effects):
                        coupling_score += 1

        # factor to normalize coupling score
        factor = math.factorial(len(self.actions)) if len(self.actions) > 1 else 1
        coupling_score /= factor  # Normalize by number of actions

        ################# average number of precond and effects
        avg_preconds = sum(len(preconds) for preconds in action_precond_list.values()) / (len(action_precond_list) or 1)
        avg_effects = sum(len(effs) for effs in action_effect_list.values()) / (len(action_effect_list) or 1)


        result = {
            "domain": self.domain_name,
            "num_predicates": len(self.predicates),  ### number of predicates
            "num_functions": len(self.functions),  ### number of functions
            "num_actions": len(self.actions),   ### number of actions
            "requirements": self.requirements,  ### the requirements of the domain
            "num_types": len(self.types),  ### the types of the domain
            "interdependency_score": round(interdependency_score, 2), #### interdependency score
            "action_coupling_score": coupling_score,  ### coupling score
            "avg_preconditions": round(avg_preconds, 2),  #### average number of preconditions per action
            "avg_effects": round(avg_effects, 2),   #### average number of effects per action
        }
        return result, self.score_calculation(result)



    def score_calculation(self, complexity_result):
        score = 0.0
        for key, value in complexity_result.items():
            if key in self.weights:
                # print("comp key:", key)
                score += value * self.weights[key]
            elif key == "requirements":
                for req in value:
                    # print("Requirement:", req)
                    score += requirement_weights.get(req, 0)
        return round(score, 2)



if __name__ == "__main__":

    analysis = PDDLDomainComplexity()
    score_dict = {}
    dataset_root = 'uav_domain_benchmark'

    for domain_dir in os.listdir(dataset_root):
        print("===== Processing domain:", domain_dir)
        domain_path = os.path.join(dataset_root, domain_dir)
        pddl_domain_file = os.path.join(domain_path, "./pddl/domain.pddl")

        if os.path.isdir(domain_path) and os.path.isfile(pddl_domain_file):
            with open(pddl_domain_file, "r", encoding="utf-8") as f:
                domain_pddl = f.read().strip()
                analysis.parse(domain_pddl)
                result, score = analysis.compute_complexity()
                score_dict[domain_dir] = score
                analysis.reset()
    # according to the score, sort the domains
    sorted_domains = sorted(score_dict.items(), key=lambda x: x[1], reverse=True)
    print(sorted_domains)

