import os
import glob
from llm_model import GPT_Chat

result_log_dir = 'results/'
date_str = '2025-07-29-01-20'
engine = 'deepseek-chat'  # 'gpt-4.1-mini-2025-04-14'  'deepseek-chat'


source_root = 'uav_domain_benchmark/'

problem_name_list = ['simple1.pddl', 'simple2.pddl', 'simple3.pddl',
                     'medium1.pddl', 'medium2.pddl', 'medium3.pddl',
                     'hard1.pddl', 'hard2.pddl', 'hard3.pddl']

def get_source_domain(domain_name):
    source_domain = os.path.join(source_root, domain_name)
    path = os.path.join(source_domain, 'pddl/domain.pddl')
    if not os.path.exists(path):
        raise FileNotFoundError(f"Source domain path {path} does not exist.")

    with open(path, 'r') as file:
        content = file.read()
            
    return content

def get_source_problem(domain_name, problem_name):
    source_domain = os.path.join(source_root, domain_name)
    path = os.path.join(source_domain, f'pddl/{problem_name}')
    if not os.path.exists(path):
        raise FileNotFoundError(f"Source problem path {path} does not exist.")

    with open(path, 'r') as file:
        content = file.read()
            
    return content


def get_result_domain(domain_name, prompt_method):
    result_domain = os.path.join(result_log_dir, date_str, engine, domain_name, prompt_method)
    if not os.path.exists(result_domain):
        raise FileNotFoundError(f"Result domain path {result_domain} does not exist.")
    
    file_paths = glob.glob(os.path.join(result_domain, '**', '*domain.pddl'), recursive=True)
    
    if not file_paths or len(file_paths) > 1:
        raise FileNotFoundError(f"No domain files found in {result_domain}.")

    for file_path in file_paths:
        with open(file_path, 'r') as file:
            content = file.read()
            print(f"Read from: {file_path}")
    
    return content


def prompt_template(domain_name, problem_name, prompt_method):
    source_domain = get_source_domain(domain_name)
    source_problem = get_source_problem(domain_name, problem_name)
    result_domain = get_result_domain(domain_name, prompt_method)
    
    prompt = f"""
You are an AI assistant that generates a valid PDDL problem.

You are given:
1. domain1.pddl: the ground-truth domain.
2. problem1.pddl: the ground-truth problem that works with domain1.pddl.
3. domain2.pddl: an LLM-generated domain that is similar but not identical to domain1.pddl.

Your task is to generate problem2.pddl, a new problem that:
1. is compatible with domain2.pddl,
2. The initial states, final goals and cost functions of problem2.pddl should be consist with what problem1.pddl defined.
3. Reflects necessary adaptations due to the differences between domain1.pddl and domain2.pddl.

Instructions:
1. Output must be a valid and complete PDDL problem, compatible with domain2.pddl.
2. you can ignore the unnecessary comments
3. Do not include any extra text, comments, or explanations - output only the problem2.pddl content.

- domain1.pddl:
{source_domain}

- problem1.pddl:
{source_problem}

- domain2.pddl:
{result_domain}

- problem2.pddl:
"""
    
    return prompt



def problem_generator():
    gpt_engine = "gpt-4.1-mini-2025-04-14"
    
    llm_gpt = GPT_Chat(engine=gpt_engine)

    prompt_method_restart_list = ['basic_best', 
                                  'basic_blockworld', 
                                  'basic_cot',
                                  'basic_cot_best']
    restart_domain = 'Watering'
    restart_domain_signal = 0
    restart_method = 'basic_best'
    restart_method_signal = 0
    restart_problem = 'simple1.pddl'
    restart_problem_signal = 0


    for domain_name in os.listdir(source_root):
        if domain_name == '.git' or domain_name == '.gitignore' or domain_name == 'val_plans' or domain_name == 'README.md' or domain_name == 'BlockWorld':
            continue
        
        if domain_name != restart_domain:
            continue

        if domain_name == restart_domain:
            restart_domain_signal = 1
            print(f"Restarting from domain: {domain_name}")
        if restart_domain_signal == 0:
            print(f"Skipping domain: {domain_name} until restart signal is set.")
            continue
        print(f"Processing domain: {domain_name}")
        
        ### get the source problems
        for problem_name in problem_name_list:

            if problem_name == restart_problem:
                restart_problem_signal = 1
                print(f"Restarting from problem: {problem_name}")
            if restart_problem_signal == 0:
                print(f"Skipping problem: {problem_name} until restart signal is set.")
                continue
            print(f"Processing problem: {problem_name}")


            ### for all prompt methods in this domain in the result
            for prompt_method in prompt_method_restart_list:

                if prompt_method == restart_method:
                    restart_method_signal = 1
                    print(f"Restarting from method: {prompt_method}")
                if restart_method_signal == 0:
                    print(f"Skipping method: {prompt_method} until restart signal is set.")
                    continue
                print(f"Processing method: {prompt_method}")


                ### generate the prompt
                prompt = prompt_template(domain_name, problem_name, prompt_method)
                print(f"Prompt generated for {domain_name}, {problem_name}, {prompt_method}.")

                _, llm_output = llm_gpt.get_response(prompt, max_retry=3, verbose=True)

                #### save the output
                result_dir = os.path.join(result_log_dir, date_str, engine, domain_name, prompt_method, 'pddl')
                os.makedirs(result_dir, exist_ok=True)
                with open(os.path.join(result_dir, f'{problem_name}'), 'w') as file:
                    file.write(llm_output)

                


if __name__ == "__main__":
    problem_generator()
    print("Problem generation completed.")
