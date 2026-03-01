"""
A script to evaluate the syntax error of llm generated PDDL domain on our dataset.
1. use different prompt methods and compare.
2. use different LLMs and compare.
"""

import os
import sys
from action_gen import action_generator
import json
import copy

from datetime import datetime


def dict_reset(dict_obj):
    """
    Reset the dictionary to have all keys with value 0.
    """
    for key in dict_obj.keys():
        dict_obj[key] = 0
    return dict_obj



##############  generate llm domain ##################
def syntax_eval():

    date_str = datetime.today().strftime('%Y-%m-%d-%H-%M')

    dataset_root = "uav_domain_benchmark"
    engine_list = ['deepseek-chat']  # deepseek-chat  gpt-4.1-mini-2025-04-14


###############  in case any generation fail because of the format of output, restart the evaluation from the stop point:
    prompt_method_restart_list = [
        'basic_blockworld',
        'basic_best',
        'basic_cot',
        'basic_cot_best'
    ]

    restart_domain = 'Watering'  
    restart_domain_signal = 0
    restart_method = 'basic_blockworld'
    restart_method_signal = 0
    restart_engine = 'deepseek-chat'   # 'gpt-4.1-mini-2025-04-14'  'deepseek-chat'
    restart_engine_signal = 0


    total_error_types_dict =      {'has_unsupported_keywords': 0,
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

    ##########  for all available models  ###########

    for engine in engine_list:

        if engine == restart_engine:
            restart_engine_signal = 1
            print(f"Restarting from engine: {engine}")
        if restart_engine_signal == 0:
            print(f"Skipping engine: {engine} until restart signal is set.")
            continue

        print(f"Using engine: {engine}")


        ##########  for all available domains  ###########
        for dataset_domain in os.listdir(dataset_root):
                
            if dataset_domain != restart_domain:
                continue
            
            if dataset_domain == restart_domain:
                restart_domain_signal = 1
                print(f"Restarting from domain: {dataset_domain}")
            if restart_domain_signal == 0:
                print(f"Skipping domain: {dataset_domain} until restart signal is set.")
                continue
            if dataset_domain == 'BlockWorld' or dataset_domain == ".git" or dataset_domain == ".gitignore" or dataset_domain == "README.md":
                continue
            

            print(f"Processing domain: {dataset_domain}")



            ##########  for all available prompt methods  ###########

            for prompt_method in prompt_method_restart_list:

                if prompt_method == restart_method:
                    restart_method_signal = 1
                    print(f"Restarting from prompt method: {prompt_method}")
                if restart_method_signal == 0:
                    print(f"Skipping method: {prompt_method} until restart signal is set.")
                    continue
                print(f"Using prompt method: {prompt_method}")
                # for all the domains in the dataset:
                dict_reset(total_error_types_dict)
                count = 0

                result_log_dir = f'results/{date_str}/{engine}/{dataset_domain}/{prompt_method}/'
                os.makedirs(result_log_dir, exist_ok=True)


                error_type_total = action_generator(
                    _domain_name_str=dataset_domain,
                    _engine=engine,
                    _prompt_method=prompt_method,
                    _result_log_dir=result_log_dir
                )


                for key in total_error_types_dict.keys():
                    for key1 in error_type_total.keys():
                        if key == key1:
                            total_error_types_dict[key] += error_type_total[key1]
                

                count += 1

                print(f"Save Total error types for {engine} with domain {dataset_domain} for this prompt method to json file:")

                ######### save the total error types to a json file
                with open(os.path.join(f'results/{date_str}/{engine}/{dataset_domain}/{prompt_method}/', f'{engine}_{dataset_domain}_{prompt_method}_error_count.json'), "w", encoding="utf-8") as f:
                    json.dump(total_error_types_dict, f, indent=4, ensure_ascii=False)
            

            ############
            # return



def total_error_count():
    prompt_method_restart_list = [
        'basic_best',
        'basic_blockworld',
        'basic_cot',
        'basic_cot_best'
    ]

    total_error_types_dict =   {'has_unsupported_keywords': 0,
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
    
    total_error_types_dict_simple = copy.deepcopy(total_error_types_dict)
    total_error_types_dict_complex = copy.deepcopy(total_error_types_dict)
    


    domain_comp = [('MultiCamLand', 15.23), ('MovableObs', 12.41), ('CeilingPaint', 11.48), 
                   ('SpeedAdapt', 8.82), ('GraspFruit', 8.69), ('Watering', 8.3), 
                   ('MaintenanceComponent', 7.77), ('AirPassenger', 7.5), ('DeliveryDurative', 6.92), 
                   ('DeliveryCapacity', 6.89), ('MedsDeliveryEnergy', 6.61), ('GraspDelivery', 6.23), 
                   ('CityCargo', 5.95), ('Gate', 5.7), ('MarsExploration', 5.58), ('MealDelivery', 5.4), 
                   ('BlockWorld', 5.23), ('DeliveryPriority', 5.05), ('TerrainAdapt', 5.05), 
                   ('WindDisturbance', 4.95), ('GridExplore', 4.94), ('Tracking', 4.92), ('Perching', 4.89), 
                   ('Landing', 4.42), ('2DNavigation', 4.39), ('AirPollution', 4.27), 
                   ('ForestFireCollaboration', 4.21), ('MedsDelivery', 4.21), ('Delivery', 4.15), 
                   ('SimpleNavigation', 3.11), ('HouseNavigation', 2.79)]

    simple_domain_list = [d[0] for d in domain_comp if d[1] <= 5.24]
    complex_domain_list = [d[0] for d in domain_comp if d[1] > 5.24]
    
    engine = 'gpt-4.1-mini-2025-04-14'  # 'gpt-4.1-mini-2025-04-14'  'deepseek-chat'
    result_root = r'results/2025-07-15-21-58/gpt-4.1-mini-2025-04-14'
    # result_root = r'results\2025-07-29-01-20\deepseek-chat'

   
    for prompt_method in prompt_method_restart_list:

        for domain_name in os.listdir(result_root):
            if domain_name == '.git' or domain_name == '.gitignore' or domain_name == 'val_plans' or domain_name == 'README.md' or domain_name == 'BlockWorld':
                continue


            error_file_path = os.path.join(result_root, domain_name, prompt_method, f'{engine}_{prompt_method}_error_count.json')
            if not os.path.exists(error_file_path):
                print(f"Error file not found for {domain_name} - {prompt_method}.")
                continue
            
            with open(error_file_path, "r", encoding="utf-8") as f:
                error_count = json.load(f)

            for key in total_error_types_dict.keys():
                if key in error_count:
                    if domain_name in simple_domain_list:
                        total_error_types_dict_simple[key] += error_count[key]
                    elif domain_name in complex_domain_list:
                        total_error_types_dict_complex[key] += error_count[key]
                    total_error_types_dict[key] += error_count[key]

        print(f"Total error count across all domains for method {prompt_method}:")
        print(total_error_types_dict)
        print('=============================\n\n')
        print(f"Total error count across simple domains for method {prompt_method}:")
        print(total_error_types_dict_simple)
        print('=============================\n\n')
        print(f"Total error count across complex domains for method {prompt_method}:")
        print(total_error_types_dict_complex)
        print('=============================\n\n')

        total_error_types_dict = {k: 0 for k in total_error_types_dict}  
        total_error_types_dict_simple = {k: 0 for k in total_error_types_dict_simple}
        total_error_types_dict_complex = {k: 0 for k in total_error_types_dict_complex}



if __name__ == '__main__':

    # syntax_eval()  # domain generation
    # print("domain generation completed.")

    total_error_count()
    print("Syntax evaluation completed.")