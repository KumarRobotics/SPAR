########### get all the actions from the database and save them in a json file ###########
########### map all the action to their database id and action name in pddl ###########

import os
import json

def collect_action_descriptions_with_keys(dataset_root, output_file):
    combined_index = {}

    for domain_dir in os.listdir(dataset_root):
        domain_path = os.path.join(dataset_root, domain_dir)
        action_file = os.path.join(domain_path, "action_desc.json")

        if os.path.isdir(domain_path) and os.path.isfile(action_file):
            with open(action_file, "r", encoding="utf-8") as f:
                action_data = json.load(f)

            for action_name, info in action_data.items():
                desc = info.get("desc")
                action_name_in_pddl = info.get("name_in_pddl")
                abs_action_desc = info.get("abstract_desc")
                if desc:
                    key = f"{desc}"
                    if key not in combined_index:
                        combined_index[key] = []
                    combined_index[key].append(domain_dir)
                    combined_index[key].append(action_name_in_pddl)
                    combined_index[key].append(action_name)
                    combined_index[key].append(abs_action_desc)

    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(combined_index, f, indent=2, ensure_ascii=False)

    print(f"Saved combined action descriptions to: {output_file}， total actions num: {len(combined_index)}")



if __name__ == "__main__":
    dataset_root = "uav_domain_benchmark"
    save_path = os.path.join("prompts", "action_lib.json")
    collect_action_descriptions_with_keys(dataset_root, save_path)
