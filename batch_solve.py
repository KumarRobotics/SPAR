from planner.solver import run_enhsp, parse_plan, save_new_plan
import os
import re
from collections import defaultdict


if __name__ == "__main__":

    java_path = os.environ.get("JAVA_BIN", "java")
    enhsp_jar_path = os.path.join("planner", "enhsp-20.jar")

    restart_domain = 'Watering'  # 'Watering'  'CityCargo'
    restart_domain_signal = 0
           

    result_log_dir = 'results/'
    date_str = '2025-07-15-21-58'
    engine = 'gpt-4.1-mini-2025-04-14'  #'gpt-4.1-mini-2025-04-14'  'deepseek-chat'

    prompt_method_restart_list = ['basic_best', 
                                  'basic_blockworld', 
                                  'basic_cot',
                                  'basic_cot_best']

    root = os.path.join(result_log_dir, date_str, engine)


    ### create a len(os.listdir(root)) x len(prompt_method_restart_list) x len(os.listdir(os.path.join(root, '2DNavigation', 'basic_blockworld', 'pddl'))) matrix
    success_matrix = {}

    count = 0

    for domain_name in os.listdir(root):
        if domain_name == '.git' or domain_name == 'val_plans' or domain_name == '.gitignore' or domain_name == 'README.md' or domain_name == 'BlockWorld':
            continue
        
        # if domain_name != restart_domain:
        #     print(f"Skipping domain: {domain_name} until restart signal is set.")
        #     continue
        ###########  testing breaking point
        # if domain_name not in restart_domain:
        #     print(f"Skipping domain: {domain_name} until restart signal is set.")
        #     continue
            

        print(f"Processing domain: {domain_name}")

        success_matrix[domain_name] = {}

        for prompt_method in prompt_method_restart_list:

            success_matrix[domain_name][prompt_method] = {}

            domain_file = os.path.join(root, domain_name, prompt_method, f"{engine}_{prompt_method}_domain.pddl")

            for problem_name in os.listdir(os.path.join(root, domain_name, prompt_method, 'pddl')):
                if not problem_name.endswith('.pddl'):
                    continue


                print(f"Processing problem: {problem_name}")

                problem_file = os.path.join(root, domain_name, prompt_method, 'pddl', problem_name)

                # Run the ENHSP solver
                out, err = run_enhsp(java_path, enhsp_jar_path, domain_file, problem_file)
                # Parse the plan from the output

                valid, plan = parse_plan(out)
                
                if valid:
                    
                    #############  special cases for gpt-4.1-mini-2025-04-14 and deepseek-chat
                    if engine == 'gpt-4.1-mini-2025-04-14':

                        # for baseline, since the generated domain didn't catch the priority, 
                        # we mark the problem involving multi-package delivering as false 
                        # even it can be solved since we can't formulate the priority in the initial state
                        if domain_name == "DeliveryPriority" and prompt_method == "basic_blockworld":
                            if problem_name in ['simple3.pddl', 'medium1.pddl', 'medium2.pddl', 'medium3.pddl', 'hard1.pddl', 'hard2.pddl', 'hard3.pddl']:
                                print(f"No valid plan found for {domain_name} - {problem_name} using {prompt_method}.")
                                success_matrix[domain_name][prompt_method][problem_name] = False
                                continue
                        
                        # for baseline: different uav should have different control rate, 
                        # so hard1,hard2,hard3 problems can't be formulated correctly
                        if domain_name == "Gate" and prompt_method == "basic_blockworld":
                            if problem_name in ['hard1.pddl', 'hard2.pddl', 'hard3.pddl']:
                                print(f"No valid plan found for {domain_name} - {problem_name} using {prompt_method}.")
                                success_matrix[domain_name][prompt_method][problem_name] = False
                                continue

                        # for baseline: mark action is wrong, so all the problem file related 
                        # to action mark are wrong, the initial state of these problems can't be formulated correctly
                        if domain_name == "GridExplore" and prompt_method == "basic_blockworld":
                            if problem_name in ['simple1.pddl', 'simple2.pddl', 'medium1.pddl', 'medium2.pddl', 'medium3.pddl', 'hard1.pddl', 'hard2.pddl', 'hard3.pddl']:
                                print(f"No valid plan found for {domain_name} - {problem_name} using {prompt_method}.")
                                success_matrix[domain_name][prompt_method][problem_name] = False
                                continue

                        # the goals of these problems can not be formulated correctly
                        if domain_name == "HouseNavigation" and (prompt_method == "basic_blockworld" or prompt_method == "basic_cot"):
                            if problem_name in ['simple3.pddl', 'medium1.pddl', 'medium2.pddl', 'medium3.pddl', 'hard1.pddl', 'hard2.pddl', 'hard3.pddl']:
                                print(f"No valid plan found for {domain_name} - {problem_name} using {prompt_method}.")
                                success_matrix[domain_name][prompt_method][problem_name] = False
                                continue

                        # the goals of these problems can not be formulated correctly
                        if domain_name == "SimpleNavigation" and prompt_method == "basic_cot":
                            if problem_name in ['simple2.pddl', 'simple3.pddl', 'medium1.pddl', 'medium2.pddl', 'medium3.pddl', 'hard1.pddl', 'hard2.pddl', 'hard3.pddl']:
                                print(f"No valid plan found for {domain_name} - {problem_name} using {prompt_method}.")
                                success_matrix[domain_name][prompt_method][problem_name] = False
                                continue


                    elif engine == 'deepseek-chat':
                        
                        if domain_name == "AirPassenger" and prompt_method == "basic_cot_best":
                            if problem_name == "hard3.pddl":
                                print(f"No valid plan found for {domain_name} - {problem_name} using {prompt_method}.")
                                success_matrix[domain_name][prompt_method][problem_name] = False
                                continue
                        
                        if domain_name == "HouseNavigation" and prompt_method == "basic_cot":
                            if problem_name in [ 'simple3.pddl', 'medium1.pddl', 'medium2.pddl', 'medium3.pddl', 'hard1.pddl', 'hard2.pddl', 'hard3.pddl']:
                                print(f"No valid plan found for {domain_name} - {problem_name} using {prompt_method}.")
                                success_matrix[domain_name][prompt_method][problem_name] = False
                                continue

                        if domain_name == "MultiCamLand" and (prompt_method == "basic_cot" or prompt_method == "basic_blockworld"):
                            if problem_name in ['simple1.pddl', 'simple2.pddl', 'simple3.pddl', 'medium1.pddl', 'medium2.pddl', 'medium3.pddl', 'hard1.pddl', 'hard2.pddl', 'hard3.pddl']:
                                print(f"No valid plan found for {domain_name} - {problem_name} using {prompt_method}.")
                                success_matrix[domain_name][prompt_method][problem_name] = False
                                continue

                        if domain_name == "SimpleNavigation" and prompt_method == "basic_cot":
                            if problem_name in [ 'simple3.pddl', 'medium1.pddl', 'medium2.pddl', 'medium3.pddl', 'hard1.pddl', 'hard2.pddl', 'hard3.pddl']:
                                print(f"No valid plan found for {domain_name} - {problem_name} using {prompt_method}.")
                                success_matrix[domain_name][prompt_method][problem_name] = False
                                continue

                        if domain_name == "SpeedAdapt" and (prompt_method == "basic_cot" or prompt_method == "basic_blockworld" or prompt_method == "basic_best"):
                            if problem_name in ['simple1.pddl', 'simple2.pddl',  'simple3.pddl', 'medium2.pddl', 'medium3.pddl', 'hard1.pddl', 'hard2.pddl', 'hard3.pddl']:
                                print(f"No valid plan found for {domain_name} - {problem_name} using {prompt_method}.")
                                success_matrix[domain_name][prompt_method][problem_name] = False
                                continue

                        if domain_name == "Tracking" and (prompt_method == "basic_cot" or prompt_method == "basic_blockworld" or prompt_method == "basic_best" or prompt_method == "basic_cot_best"):
                            if problem_name in ['simple2.pddl', 'simple3.pddl', 'medium1.pddl', 'medium2.pddl', 'medium3.pddl', 'hard1.pddl', 'hard2.pddl', 'hard3.pddl']:
                                print(f"No valid plan found for {domain_name} - {problem_name} using {prompt_method}.")
                                success_matrix[domain_name][prompt_method][problem_name] = False
                                continue


                    with open(problem_file, 'r') as file:
                        pddl_problem_text = file.read()

                    problem_match = re.search(r'\(define\s+\(problem\s+([^\s\)]+)', pddl_problem_text)
                    problem_header_name = problem_match.group(1) if problem_match else None

                    domain_match = re.search(r'\(:domain\s+([^\s\)]+)', pddl_problem_text)
                    domain_header_name = domain_match.group(1) if domain_match else None

                    domain_header_name = f";;!domain: {domain_header_name}\n"
                    problem_header_name = f";;!problem: {problem_header_name}\n"

                    # Save the generated plan
                    save_new_plan(plan, domain_header_name, problem_header_name, problem_name.split('.')[0],
                                os.path.join(root, domain_name, prompt_method, 'pddl'))
                    
                    
                    print(f"Plan successfully generated for {domain_name} - {problem_name} using {prompt_method}.")
                    success_matrix[domain_name][prompt_method][problem_name] = True


                else:
                    print(f"No valid plan found for {domain_name} - {problem_name} using {prompt_method}.")
                    success_matrix[domain_name][prompt_method][problem_name] = False




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


    stats = defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: [0, 0])))

    for domain_name, methods in success_matrix.items():

        if domain_name in simple_domain_list:
            domain_type = "simple"
        elif domain_name in complex_domain_list:
            domain_type = "complex"
        
        for method, problems in methods.items():
            for problem_name, success in problems.items():
                if problem_name.startswith('simple'):
                    problem_type = "simple"
                elif problem_name.startswith('medium'):
                    problem_type = "medium"
                elif problem_name.startswith('hard'):
                    problem_type = "hard"
                stats[method][domain_type][problem_type][1] += 1  # total count
                if success:
                    stats[method][domain_type][problem_type][0] += 1  # success count




    # print
    method_totals = defaultdict(lambda: [0, 0])  # method -> [success, total]
    method_domain_problem_totals = defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: [0, 0])))
    # method -> domain_type -> problem_type -> [success, total]


    for method in stats:
        for domain_type in stats[method]:
            for problem_type in stats[method][domain_type]:
                success_count, total_count = stats[method][domain_type][problem_type]
                success_rate = (success_count / total_count) * 100 if total_count > 0 else 0
                # print(f"Method: {method}, Domain: {domain_type}, Problem: {problem_type} - "
                #     f"Success Rate: {success_rate:.2f}% ({success_count}/{total_count})")

            
                method_totals[method][0] += success_count
                method_totals[method][1] += total_count

                
                method_domain_problem_totals[method][domain_type][problem_type][0] += success_count
                method_domain_problem_totals[method][domain_type][problem_type][1] += total_count

    print("\nOverall Success Rate by Method:")
    for method, (success_count, total_count) in method_totals.items():
        overall_rate = (success_count / total_count) * 100 if total_count > 0 else 0
        print(f"Method: {method} - Total Success Rate: {overall_rate:.2f}% ({success_count}/{total_count})")


    print("\nDetailed Success Rate by Method, Domain Type, and Problem Type:")
    for method in method_domain_problem_totals:
        for domain_type in ['simple', 'complex']:  
            for problem_type in ['simple', 'medium', 'hard']:
                success_count, total_count = method_domain_problem_totals[method][domain_type][problem_type]
                if total_count == 0:
                    continue
                success_rate = (success_count / total_count) * 100
                print(f"Method: {method}, Domain: {domain_type}, Problem: {problem_type} - "
                    f"Success Rate: {success_rate:.2f}% ({success_count}/{total_count})")
                

    ####  print all the successful rate for each method in each domain
    print("\nSuccess Rate for Each Method in Each Domain:")

    for domain_name, methods in success_matrix.items():
        for method, problems in methods.items():
            success_count = sum(1 for success in problems.values() if success)
            total_count = len(problems)
            success_rate = (success_count / total_count) * 100 if total_count > 0 else 0
            print(f" For domain {domain_name}, Method: {method} - Success Rate: {success_rate:.2f}% ({success_count}/{total_count})")
            
