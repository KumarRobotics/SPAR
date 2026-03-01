"""
Helper script to modify the domain_example_prompt.txt file in the dataset all in once.
So I don't have to modify them manually every time I change the prompt template.
"""

import re
from copy import deepcopy
import json
import os

def replace_example_idx(text: str, index: int, new_header: str) -> str:
    """
    change the example index to action name.
    """
    # pattern = rf"(?m)^Example\s+{index}\s*\n"
    # pattern = f"{new_header}\n"
    pattern = f"{index}. {new_header}\n"
    replacement = f"Example {index}. {new_header}\n"
    updated_text = re.sub(pattern, replacement, text, count=1)
    return updated_text


def remove_example_header(text: str) -> str:
    """
    Remove the text before first example: Example 1.
    """
    pattern = rf"(?m)^Example\s+{1}\s*\n"
    match = re.search(pattern, text)
    if match:
        return text[match.start():] 
    else:
        return text 
    
def remove_back_instruction(text: str) -> str:
    """
    Remove the instruction at the end of the text.
    """
    pattern = r"(?m)^Here is the task"
    match = re.search(pattern, text)
    if match:
        return text[:match.start()]
    else:
        return text


def change_New_Predicates_or_New_Functions_lines(text: str) -> str:
    """
    Change the header of New Predicates or New Functions to a new header.
    """
    pattern1 = r'New Predicates: \(Please write: "No newly defined predicate" below if there is no new predicate\)'
    replacement1 = 'New Predicates:(Please write: "No newly defined predicate" below if there is no new predicate)\n'

    pattern2 = r'New Functions: \(Please write: "No newly defined function" below if there is no new function\)'
    replacement2 = 'New Functions:(Please write: "No newly defined function" below if there is no new function)\n'

    updated_text = re.sub(pattern1, replacement1, text)
    updated_text = re.sub(pattern2, replacement2, updated_text)

    return updated_text


def add_neg_precond_to_every_domain(obj_requirement):
    if "negative-preconditions" not in obj_requirement['requirements']:
        obj_requirement['requirements'].append("negative-preconditions")
    if "numeric-fluents" not in obj_requirement['requirements']:
        obj_requirement['requirements'].append("numeric-fluents")
    if "typing" not in obj_requirement['requirements']:
        obj_requirement['requirements'].append("typing")
    if "equality" not in obj_requirement['requirements']:
        obj_requirement['requirements'].append("equality")
    

    return obj_requirement



if __name__ == "__main__":
        
    dataset_root = "uav_domain_benchmark"
    # for all the domains in the dataset:
    for dataset_domain in os.listdir(dataset_root):

        if dataset_domain == ".git" or dataset_domain == ".gitignore" or dataset_domain == "README.md":
            continue

        print(f"Processing domain: {dataset_domain}")
        
        with open(os.path.join(f"uav_domain_benchmark\{dataset_domain}", f'hierarchy_requirements.json')) as f:
            content = json.load(f)

        updated = add_neg_precond_to_every_domain(deepcopy(content))
        # print(f"Updated requirements for {dataset_domain}: {updated}")

        ### write the updated content back to the file
        with open(os.path.join(f"uav_domain_benchmark\{dataset_domain}", f'hierarchy_requirements.json'), 'w', encoding='utf-8') as f:
            json.dump(updated, f, indent=4, ensure_ascii=False)

    
