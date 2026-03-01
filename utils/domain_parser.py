"""
A script to parse the PDDL domain, also the LLM output to specific output format
"""

import re
from typing import Set, Tuple, List


def tokenize_pddl(text: str) -> List[str]:
    return re.findall(r'\(|\)|[^\s()]+', text)


def parse_tokens(tokens: List[str]) -> List:
    stack = []
    current = []
    for token in tokens:
        if token == '(':
            stack.append(current)
            current = []
        elif token == ')':
            last = current
            current = stack.pop()
            current.append(last)
        else:
            current.append(token)
    return current[0] if current else []


def traverse_expr(expr, fluent_names: Set[str]):
    if not isinstance(expr, list) or len(expr) == 0:
        return

    head = expr[0]
    
    if head in {'and', 'not', 'increase', 'decrease', 'assign', 'when', 'forall', 'exists', 'imply', 'or'}:
        for subexpr in expr[1:]:
            traverse_expr(subexpr, fluent_names)
    elif head in {'>=', '<=', '<', '>', '=', '+', '-', '*', '/'}:
        for subexpr in expr[1:]:
            traverse_expr(subexpr, fluent_names)
    else:
        fluent_names.add(head)
        for arg in expr[1:]:
            traverse_expr(arg, fluent_names)


def parse_fluent_names_from_action(action_str: str) -> Set[str]:
    fluent_names = set()
    tokens = tokenize_pddl(action_str)
    nested = parse_tokens(tokens)

    for i, item in enumerate(nested):
        if isinstance(item, str) and item in {':precondition', ':effect'}:
            expr_block = nested[i + 1]
            traverse_expr(expr_block, fluent_names)

    return fluent_names


def extract_action_block(pddl_text, action_name):
    pattern = rf"\(:action\s+{re.escape(action_name)}\b"
    match = re.search(pattern, pddl_text)
    if not match:
        return None

    start = match.start()
    open_parens = 0
    print(start)

    for i in range(start, len(pddl_text)):
        print(pddl_text[i])
        if pddl_text[i] == '(':
            open_parens += 1
        elif pddl_text[i] == ')':
            open_parens -= 1
            if open_parens == 0:
                return pddl_text[start:i+1]
    
    return None


def parse_pddl_block(domain_str: str, block_type) -> str:
    """
    block type can be (:predicates or (:functions or :parameters
    """
    start_idx = domain_str.find(block_type)
    if start_idx < 0:
        return []  # Return empty set if no predicates found

    # 提取从 fluent_type 开始后到第一个匹配括号结束的部分
    rest = domain_str[start_idx:]
    open_parens = 0
    end_idx = None
    for i, char in enumerate(rest):
        if char == '(':
            open_parens += 1
        elif char == ')':
            open_parens -= 1
            if open_parens == 0:
                end_idx = i
                break

    if end_idx is None:
        return []  # Malformed input, skip

    predicate_block = rest[len(block_type):end_idx+1].strip()
    return predicate_block


def parse_domain_fluents_list(domain_str: str, fluent_type: str) -> Set[str]:
    """
    fluent_type can be (:predicates or (:functions
    """
    predicate_names = set()
    predicate_block = parse_pddl_block(domain_str, fluent_type)

    # 遍历每一行，提取 predicate 名字
    for line in predicate_block.splitlines():
        line = line.strip()
        if not line or line.startswith(";"):
            continue  # Skip empty or comment lines
        if line.startswith('('):
            line = line[1:]
        if line.endswith(')'):
            line = line[:-1]
        parts = line.strip().split()
        if parts:
            predicate_names.add(parts[0])

    return predicate_names









pddl_action = """


(:predicates ;todo: define predicates here
    (at ?r - robot ?p - position)
    (connect ?p0 - position ?p1 - position)
    (wind ?p - position)
    (blow-to ?p0 - position ?p1 - position)
)


(:functions ;todo: define predicates here
    (at1 ?r - robot ?p - position)
    (connect1 ?p0 - position ?p1 - position)
    (wind1 ?p - position)
    (blow-to1 ?p0 - position ?p1 - position)
)

(:action move
    :parameters (?r - robot ?p0 - position ?p1 - position)
    :precondition (and 
        (at ?r ?p0) 
        (connect ?p0 ?p1) 
        (not (wind ?p0))
        (= (t1 ?r) (+ (t2 ?r) 2))
    )
    :effect (and 
        (not (at ?r ?p0)) 
        (at ?r ?p1) 
        (increase (cost) 1) 
    )
)
"""

fluent_names = parse_domain_fluents_list(pddl_action, '(:functions')
print("fluent_names:", fluent_names)



