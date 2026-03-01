## D:\java\jdk-15.0.1\bin\java.exe
import subprocess
import os
import re



def run_enhsp(java_path, enhsp_jar_path, domain_file, problem_file):

    for path in [java_path, enhsp_jar_path, domain_file, problem_file]:
        if not os.path.exists(path):
            raise FileNotFoundError(f"❌ File not found: {path}")

    cmd = [java_path, "-jar", enhsp_jar_path,  "-o", domain_file, "-f", problem_file]
    print(f"🚀 Running ENHSP:\n{' '.join(cmd)}\n")

    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=False, timeout=20)

        print("=== STDOUT ===")
        print(result.stdout)

        print("=== STDERR ===")
        print(result.stderr)

        if "Plan Found" in result.stdout:
            print("✅ Plan successfully generated!")
        elif "No Plan Found" in result.stdout:
            print("❌ No valid plan could be found.")
        # if the solver maximum time is reached
        else:
            print("⚠️ Unknown output. Check above for details.")

    # except subprocess.TimeoutExpired:
    #     print(f"❌ Error running ENHSP: ")
    #     return '', ''
    except Exception as e:
        print(f"❌ Error running ENHSP: {e}")
        return '', ''

    return result.stdout, result.stderr


def parse_plan(output):
    if "Problem Solved" in output:
        print("Plan found in output.")
        if "Found Plan:" in output:
            plan_start = output.index("Found Plan:") + len("Found Plan:")
            plan_end = output.index("Plan-Length", plan_start)
            plan = output[plan_start:plan_end].strip()
            print(f"Plan:\n{plan}")
            return True, plan
        return False, None
    
    else:
        print("No plan found in output.")
        return False, None
    

def save_new_plan(plan, domain_header_name, problem_header_name, problem_name, result_path):
    if not os.path.exists(result_path):
        os.makedirs(result_path)

    plan_file = os.path.join(result_path, f"{problem_name}.plan")

    plan = f"{domain_header_name}\n{problem_header_name}\n" + plan
    
    with open(plan_file, 'w') as file:
        file.write(plan)
    
    print(f"Plan saved to {plan_file}")



def generate_ground_truth_plans():
    """
    Generate ground truth plans for all domains and problems using the specified LLM and prompt template.
    """


    problem_name_list = ['simple1', 'simple2', 'simple3',
                         'medium1', 'medium2', 'medium3',
                         'hard1', 'hard2', 'hard3']
    source_root = 'uav_domain_benchmark'

    java_path = os.environ.get("JAVA_BIN", "java")
    enhsp_jar_path = os.path.join("planner", "enhsp-20.jar")

    for domain_name in os.listdir(source_root):
        if domain_name == '.git' or domain_name == '.gitignore' or domain_name == 'README.md' or domain_name == 'BlockWorld':
            continue
        
        print(f"Processing domain: {domain_name}")

        gt_domain_file_path = os.path.join(source_root, domain_name, "pddl", "domain.pddl")

        for problem_name in problem_name_list:
            gt_problem_file_path = os.path.join(source_root, domain_name, "pddl", f"{problem_name}.pddl")
            gt_domain_file_path = os.path.join(source_root, domain_name, "pddl", "domain.pddl")
            with open(gt_problem_file_path, 'r') as file:
                pddl_problem_text = file.read()

            if not os.path.exists(gt_domain_file_path) or not os.path.exists(gt_problem_file_path):
                print(f"Skipping {domain_name}/{problem_name} - missing files.")
                continue
            
            out, err = run_enhsp(java_path, enhsp_jar_path, gt_domain_file_path, gt_problem_file_path)
            valid, plan = parse_plan(out)

            if valid:
                print(f"Plan successfully generated for {domain_name} - {problem_name}.")
                problem_match = re.search(r'\(define\s+\(problem\s+([^\s\)]+)', pddl_problem_text)
                problem_header_name = problem_match.group(1) if problem_match else None

                domain_match = re.search(r'\(:domain\s+([^\s\)]+)', pddl_problem_text)
                domain_header_name = domain_match.group(1) if domain_match else None

                domain_header_name = f";;!domain: {domain_header_name}\n"
                problem_header_name = f";;!problem: {problem_header_name}\n"

                # Save the generated plan
                save_new_plan(plan, domain_header_name, problem_header_name, problem_name ,
                            os.path.join(source_root, domain_name, "pddl"))
    



if __name__ == "__main__":
    
    java_path = os.environ.get("JAVA_BIN", "java")
    enhsp_jar_path = os.path.join("planner", "enhsp-20.jar")
           
    domain_file = r"results\2025-07-29-01-20\deepseek-chat\2DNavigation\basic_best\deepseek-chat_basic_best_domain.pddl"
    problem_file = r"results\2025-07-29-01-20\deepseek-chat\2DNavigation\basic_best\pddl\simple1.pddl"

    out, err = run_enhsp(java_path, enhsp_jar_path, domain_file, problem_file)
    parse_plan(out)
    print('done')

    # generate_ground_truth_plans()
    # print("Ground truth plans generated successfully.")
