import os
import re


#######  delete all the .plan files in the result
result_root = r'results/2025-07-15-21-58/gpt-4.1-mini-2025-04-14'   # 'results/2025-07-15-21-58/gpt-4.1-mini-2025-04-14'
prompt_method_restart_list = ['basic_best', 
                                  'basic_blockworld', 
                                  'basic_cot',
                                  'basic_cot_best']

for domain_name in os.listdir(result_root):
    if domain_name == '.git' or domain_name == '.gitignore' or domain_name == 'README.md' or domain_name == 'BlockWorld' or domain_name == 'val_plans':
        continue
    
    print(f"Processing domain: {domain_name}")

    for method in prompt_method_restart_list:

        pddl_dir = os.path.join(result_root, domain_name, method , "pddl")
        for file in os.listdir(pddl_dir):
            if file.endswith('.plan'):
                plan_file_path = os.path.join(pddl_dir, file)
                if os.path.exists(plan_file_path):
                    os.remove(plan_file_path)
                    print(f"Deleted plan file: {plan_file_path}")