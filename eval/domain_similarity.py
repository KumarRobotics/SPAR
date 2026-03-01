import subprocess
import os
import glob
import re


"""
Use for evaluation: 
step 1: Generate domain file using llm, make sure the action names are the same as the ground truth domain file
step 2: write the corresponding problem file(s) based on generated domain file
step 3: Get the valid plan file(s) from ground truth domain file and problem file
step 4: Validate the plan file(s) on the generated domain file and problem file
step 5: Parse the feedback info: valid or not, if not, where is the error and the advice
"""

def parse_feedback_info(feedback):
    """
    Parse the feedback info from the validation output.
    This function assumes that the feedback is in a specific format.
    Adjust the parsing logic based on the actual output format.
    """
    if "Plan valid" in feedback:
        return True, "Plan is valid."
    
    error_fb = ""

    if "Plan failed to execute" in feedback:
        if "Plan failed because of" in feedback:
        
            if "Plan Repair Advice:" in feedback:
                advice = feedback.split("Plan Repair Advice:")[1].strip()
                advice = advice.split("Failed plans:")[0].strip()
                error_fb += f"Plan failed to execute. Advice from validator: \n{advice}"

            else:
                error_fb += "Plan failed to execute, but no specific advice provided."

    return False, error_fb


def validate_plan_on_generated_domain(domain_generated, problem, plan_file):
    val_bin = os.environ.get("VAL_BIN")
    if not val_bin:
        raise RuntimeError("Missing required environment variable: VAL_BIN")

    val_command = [
        val_bin,
        "-v",
        "-t",
        "0.001",
        domain_generated,
        problem,
        plan_file
    ]

    try:
        result = subprocess.run(val_command, capture_output=True, text=True, timeout=10)
        print(result)
        is_valid, feedback = parse_feedback_info(result.stdout)
        return is_valid, feedback, result.stdout

    except subprocess.TimeoutExpired:
        print("Validation timed out.")
        return False
    except FileNotFoundError:
        print("VAL not found. Please check your installation and path.")
        return False


problem_name_list = ['simple1', 'simple2', 'simple3',
                     'medium1', 'medium2', 'medium3',
                     'hard1', 'hard2', 'hard3']
prompt_method_list = ['basic_best', 
                        'basic_blockworld', 
                        'basic_cot',
                        'basic_cot_best']

engine = 'gpt-4.1-mini-2025-04-14'  ### 'deepseek-chat'  'gpt-4.1-mini-2025-04-14'
date = '2025-07-15-21-58'  ####  '2025-07-29-01-20'   '2025-07-15-21-58'
results_path = f'results\{date}\{engine}'

test_domains = ['2DNavigation', 'Watering', 'Landing']


def domain_similarity():

    result_plan_dir = os.path.join(results_path, 'val_plans')
    os.makedirs(result_plan_dir, exist_ok=True)

    success_matrix_1 = {}
    success_matrix_2 = {}



    for domain_name in os.listdir("uav_domain_benchmark"):

        if domain_name == '.git' or domain_name == '.gitignore' or domain_name == 'README.md' or domain_name == 'BlockWorld':
            continue

        # if domain_name not in test_domains:
        #     continue
        
        print(f"Processing domain: {domain_name}")

        success_matrix_1[domain_name] = {}
        success_matrix_2[domain_name] = {}

        gt_domain_file_path = os.path.join("uav_domain_benchmark", domain_name, "pddl", "domain.pddl")



        for prompt_method in prompt_method_list:
            print(f"Processing prompt method: {prompt_method}")
            success_matrix_1[domain_name][prompt_method] = {}
            success_matrix_2[domain_name][prompt_method] = {}

            for problem_name in problem_name_list:

                gt_problem_file_path = os.path.join("uav_domain_benchmark", domain_name, "pddl", f"{problem_name}.pddl")
                gt_plan_file_path = os.path.join("uav_domain_benchmark", domain_name, "pddl", f"{problem_name}.plan")

                ### find the generated plan file
                generated_file_path = os.path.join(results_path, domain_name, prompt_method, 'pddl', f"{problem_name}.plan")
        
                if not generated_file_path or not os.path.exists(generated_file_path):
                    print(f"Generated plan file not found for {domain_name} - {problem_name} using {prompt_method}.")
                    continue

                ######  find the generated domain file and problem file
                generated_domain_file_path = os.path.join(results_path, domain_name, prompt_method, f"{engine}_{prompt_method}_domain.pddl")
                generated_problem_file_path = os.path.join(results_path, domain_name, prompt_method, 'pddl', f"{problem_name}.pddl")

                #########  exchange the header of two plan files and save them into a new folder
                with open(gt_plan_file_path, 'r') as gt_file:
                    gt_plan_content = gt_file.read()
                
                with open(generated_file_path, 'r') as gen_file:
                    gen_plan_content = gen_file.read()

                matches = re.findall(r'^;;!domain:.*|^;;!problem:.*', gt_plan_content, re.MULTILINE)
                gt_header = '\n'.join(matches)
                start_plan = gt_plan_content.find('\n', gt_plan_content.find(';;!problem:')) + 1
                gt_plan_text = gt_plan_content[start_plan:].lstrip()

                matches = re.findall(r'^;;!domain:.*|^;;!problem:.*', gen_plan_content, re.MULTILINE)
                generated_header = '\n'.join(matches)
                start_plan = gen_plan_content.find('\n', gen_plan_content.find(';;!problem:')) + 1
                gen_plan_text = gen_plan_content[start_plan:].lstrip()

                new_plan_content1 = f"{gt_header}\n{gen_plan_text}"
                new_plan_content2 = f"{generated_header}\n{gt_plan_text}"

                ### save the new plan files to result_plan_dir
                result_plan_dir = os.path.join(results_path, 'val_plans', domain_name, prompt_method, problem_name )
                os.makedirs(result_plan_dir, exist_ok=True)

                new_plan_file1 = os.path.join(result_plan_dir, f"{domain_name}_{problem_name}_{prompt_method}_gt_gen.plan")
                new_plan_file2 = os.path.join(result_plan_dir, f"{domain_name}_{problem_name}_{prompt_method}_gen_gt.plan")

                with open(new_plan_file1, 'w') as new_file:
                    new_file.write(new_plan_content1)
                with open(new_plan_file2, 'w') as new_file:
                    new_file.write(new_plan_content2)
                
                #####   validate the new plan files
                is_valid1, feedback1, stdout1 = validate_plan_on_generated_domain(gt_domain_file_path, gt_problem_file_path, new_plan_file1)
                is_valid2, feedback2, stdout2 = validate_plan_on_generated_domain(generated_domain_file_path, generated_problem_file_path, new_plan_file2)

                success_matrix_1[domain_name][prompt_method][problem_name] = is_valid1
                success_matrix_2[domain_name][prompt_method][problem_name] = is_valid2


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


    direction1_total_count = {method: {'simple': {'simple': 0, 'medium': 0, 'hard': 0},
                                    'complex': {'simple': 0, 'medium': 0, 'hard': 0}} 
                            for method in prompt_method_list}

    direction2_total_count = {method: {'simple': {'simple': 0, 'medium': 0, 'hard': 0},
                                    'complex': {'simple': 0, 'medium': 0, 'hard': 0}} 
                            for method in prompt_method_list}

    direction1_success_count = {method: {'simple': {'simple': 0, 'medium': 0, 'hard': 0},
                                        'complex': {'simple': 0, 'medium': 0, 'hard': 0}} 
                            for method in prompt_method_list}

    direction2_success_count = {method: {'simple': {'simple': 0, 'medium': 0, 'hard': 0},
                                        'complex': {'simple': 0, 'medium': 0, 'hard': 0}} 
                            for method in prompt_method_list}

    #  direction1 
    for domain_name, methods in success_matrix_1.items():
        if domain_name in simple_domain_list:
            domain_type = 'simple'
        elif domain_name in complex_domain_list:
            domain_type = 'complex'
        for method, problems in methods.items():
            for problem_name, success in problems.items():
                if 'simple' in problem_name:
                    p_level = 'simple'
                elif 'medium' in problem_name:
                    p_level = 'medium'
                elif 'hard' in problem_name:
                    p_level = 'hard'
                else:
                    continue  # skip unknown pattern

                direction1_total_count[method][domain_type][p_level] += 1
                if success:
                    direction1_success_count[method][domain_type][p_level] += 1

    # direction2
    for domain_name, methods in success_matrix_2.items():
        if domain_name in simple_domain_list:
            domain_type = 'simple'
        elif domain_name in complex_domain_list:
            domain_type = 'complex'

        for method, problems in methods.items():
            for problem_name, success in problems.items():
                if 'simple' in problem_name:
                    p_level = 'simple'
                elif 'medium' in problem_name:
                    p_level = 'medium'
                elif 'hard' in problem_name:
                    p_level = 'hard'
                else:
                    continue  # skip unknown pattern

                direction2_total_count[method][domain_type][p_level] += 1
                if success:
                    direction2_success_count[method][domain_type][p_level] += 1

    
    print("\nDetailed Success Rates for Each Method, Domain, and Problem Type:")

    for method in prompt_method_list:
        for domain_type in ['simple', 'complex']:
            for problem_type in ['simple', 'medium', 'hard']:
                # Direction 1
                total_count_1 = direction1_total_count[method][domain_type][problem_type]
                if domain_type == 'simple':
                    total_count_1 = 42  ####### there are 42 problems in simple domain for each problem level
                elif domain_type == 'complex':
                    total_count_1 = 48  ####### there are 48 problems in simple domain for each problem level
                success_count_1 = direction1_success_count[method][domain_type][problem_type]
                success_rate_1 = (success_count_1 / total_count_1 * 100) if total_count_1 > 0 else 0
                print(f"Direction 1 - Method: {method}, Domain: {domain_type}, Problem: {problem_type} "
                    f"- Success Rate: {success_rate_1:.2f}% ({success_count_1}/{total_count_1})")

                # Direction 2
                total_count_2 = direction2_total_count[method][domain_type][problem_type]
                if domain_type == 'simple':
                    total_count_2 = 42
                elif domain_type == 'complex':
                    total_count_2 = 48
                success_count_2 = direction2_success_count[method][domain_type][problem_type]
                success_rate_2 = (success_count_2 / total_count_2 * 100) if total_count_2 > 0 else 0
                print(f"Direction 2 - Method: {method}, Domain: {domain_type}, Problem: {problem_type} "
                    f"- Success Rate: {success_rate_2:.2f}% ({success_count_2}/{total_count_2})")

    #  overall success rate（ground truth 与 generated domain）
    print("\nOverall Rates of generated plan in ground truth domain:")
    for method in prompt_method_list:
        total_count = sum(direction1_total_count[method]['simple'].values()) + sum(direction1_total_count[method]['complex'].values())
        total_count = 270
        success_count = sum(direction1_success_count[method]['simple'].values()) + sum(direction1_success_count[method]['complex'].values())
        success_rate = (success_count / total_count * 100) if total_count > 0 else 0
        print(f"Method: {method} - Success Rate: {success_rate:.2f}% ({success_count}/{total_count})")

    print("\nOverall Rates of ground truth plan in generated domain:")
    for method in prompt_method_list:
        total_count = sum(direction2_total_count[method]['simple'].values()) + sum(direction2_total_count[method]['complex'].values())
        total_count = 270
        success_count = sum(direction2_success_count[method]['simple'].values()) + sum(direction2_success_count[method]['complex'].values())
        success_rate = (success_count / total_count * 100) if total_count > 0 else 0
        print(f"Method: {method} - Success Rate: {success_rate:.2f}% ({success_count}/{total_count})")


        




if __name__ == "__main__":

    # domain_gen = r"results\2025-07-15-21-58\gpt-4.1-mini-2025-04-14\2DNavigation\basic_best\gpt-4.1-mini-2025-04-14_basic_best_domain.pddl"
    # problem = r"results\2025-07-15-21-58\gpt-4.1-mini-2025-04-14\2DNavigation\basic_best\pddl\simple3.pddl"
    # plan = r"results\2025-07-15-21-58\gpt-4.1-mini-2025-04-14\2DNavigation\basic_best\pddl\simple3.plan"

    # is_valid, feedback, stdout = validate_plan_on_generated_domain(domain_gen, problem, plan)
    # print(stdout)
    domain_similarity()
