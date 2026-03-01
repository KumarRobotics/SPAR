
import os
import traceback
import json

import openai
from openai import OpenAI
from wrapt_timeout_decorator import timeout
import tenacity

import numpy as np
from sentence_transformers import SentenceTransformer

from prompts.template_generator import llm_reranker_prompt


def cosine_similarity(a, B):
    a_norm = np.linalg.norm(a)
    B_norms = np.linalg.norm(B, axis=1)
    sim = np.dot(B, a) / (B_norms * a_norm + 1e-10)
    return sim


#@timeout(dec_timeout=30, use_signals=False)
def connect_openai(client, engine, messages, temperature, max_tokens,
                   top_p, frequency_penalty, presence_penalty, stop):
    try:
        return client.chat.completions.create(
            model=engine,
            messages=messages,
            temperature=temperature,
            max_tokens=max_tokens,
            top_p=top_p,
            frequency_penalty=frequency_penalty,
            presence_penalty=presence_penalty,
            stop=stop
        )
    except Exception as e:
        print(f'[ERROR] OpenAI model error: {e}')
        raise e


class GPT_Chat:
    def __init__(self, engine, stop=None, max_tokens=1000, temperature=0, top_p=1,
                 frequency_penalty=0.0, presence_penalty=0.0):
        self.engine = engine
        if 'gpt' in engine:
            self.gpt_client = OpenAI(api_key=self._require_api_key("OPENAI_API_KEY"))
        elif 'deepseek' in engine:
            self.gpt_client = OpenAI(api_key=self._require_api_key("DEEPSEEK_API_KEY"),
                                     base_url="https://api.deepseek.com")

        self.max_tokens = max_tokens
        self.temperature = temperature
        self.top_p = top_p
        self.freq_penalty = frequency_penalty
        self.presence_penalty = presence_penalty
        self.stop = stop

    @staticmethod
    def _require_api_key(env_name):
        api_key = os.environ.get(env_name)
        if not api_key:
            raise RuntimeError(f"Missing required environment variable: {env_name}")
        return api_key

    def get_response(self, prompt, messages=None, max_retry=5, verbose=False):
        conn_success, llm_output = False, ''
        if messages is not None:
            messages = messages
        else:
            messages = [{'role': 'user', 'content': prompt}]

        try:
            r = tenacity.Retrying(
                stop=tenacity.stop_after_attempt(max_retry),
                wait=tenacity.wait_fixed(1.5),
                reraise=True
            )
            response = r.__call__(
                connect_openai,
                client=self.gpt_client,
                engine=self.engine,
                messages=messages,
                temperature=self.temperature,
                max_tokens=self.max_tokens,
                top_p=self.top_p,
                frequency_penalty=self.freq_penalty,
                presence_penalty=self.presence_penalty,
                stop=self.stop)
            llm_output = response.choices[0].message.content
            if verbose:
                print(f'[INFO] Connection success - token usage: {response.usage}')
            conn_success = True
        except Exception:
            print(traceback.format_exc())

        return conn_success, llm_output
    

    def get_embedding_np(self, text):
        """ Generate an embedding for the given text using OpenAI's API."""
        response = self.gpt_client.embeddings.create(
            input=text,
            model="text-embedding-ada-002"
        )
        return np.array(response.data[0].embedding)
    

    def search_db_file(self, dataset_name, idx, action_headers):
        prompt_path = f"uav_domain_benchmark/{dataset_name[idx]}/domain_example_prompt.txt"
        with open(prompt_path, "r", encoding="utf-8") as f:
            example_prompt = f.read().strip()
        
        cot_prompt_path = f"uav_domain_benchmark/{dataset_name[idx]}/cot_prompt.txt"
        with open(cot_prompt_path, "r", encoding="utf-8") as f:
            cot_prompt = f.read().strip()
        
        domain_desc_path = f"uav_domain_benchmark/{dataset_name[idx]}/domain_desc.txt"
        with open(domain_desc_path, "r", encoding="utf-8") as f:
            domain_desc = f.read().strip()

        ## read the action description json file and use action key to find the action idx
        action_desc_path = f"uav_domain_benchmark/{dataset_name[idx]}/action_desc.json"
        
        with open(action_desc_path, "r", encoding="utf-8") as f:
            action_desc = json.load(f)
            # get the idx of action_keys[idx] in action_desc
            action_idx = 0
            for key in action_desc.keys():
                if key == action_headers[idx]:
                    break
                action_idx += 1

        return domain_desc, example_prompt, cot_prompt, action_idx
    

    def find_best_action_domain(self, query, current_domain_name, 
                                action_lib_embed_path,
                                llm_method ,top_k=3, fine_with_llm=False, nl_query=None):
        """ 
        Find the best action domain based on the query and the cached embeddings, return the prompt template of the similar domain
        query: str, the user input query describing the action.
        current_domain_name: str, the name of the current domain.
        action_lib_embed_path: str, path to the cached action embeddings.
        top_k: int, number of top similar actions.
        """
        if fine_with_llm and nl_query is None:
            raise ValueError("If fine_with_llm is True, nl_query must be provided.")

        cache = np.load(action_lib_embed_path, allow_pickle=True)
        embedding_matrix = cache["embeddings"] 
        action_keys = cache["keys"]           
        dataset_name = cache["dataset_name"]  
        action_name_in_pddl = cache["action_name_in_pddl"]
        action_headers = cache["action_headers"]
        action_abstract_desc = cache["abs_action_desc"]

        if llm_method == 'ada':
            query_emb = self.get_embedding_np(query)
            sims = cosine_similarity(query_emb, embedding_matrix)
            
        elif llm_method == 'minilm':
            model_minilm = SentenceTransformer('./local_model/all-mpnet-base-v2')
            query_emb = model_minilm.encode(query)
            sims = model_minilm.similarity(query_emb, embedding_matrix)
            sims = sims.cpu().numpy().flatten()
            ########  idx sorted from high to low ##########

        top_indices = np.argsort(sims)[::-1][:top_k]

        best_result = {'domain_desc': [], 'example_prompt': [], 'cot_prompt': [], 'action_idx': [], 'action_nl_desc': []}

        best_result_idx = []

        for rank, idx in enumerate(top_indices, 1):
            ##### Skip if the action is from the current domain in the dataset #####
            if dataset_name[idx] == current_domain_name:
                continue

            # print(f"\n{'=' * 50}")
            # print(f"[{rank}] similarity: {sims[idx]:.4f}")
            # print(f" Action header: {action_headers[idx]}")
            # print(f" {action_keys[idx]}")
            # print(f" Found in datasets: {dataset_name[idx]}")
            # print(f" Action name in PDDL: {action_name_in_pddl[idx]}")
            # print(f" Abstract Action description: {action_abstract_desc[idx]}")
            # print(f" Current query: {query}")
            # print("" + "=" * 50 + "\n")

            best_result_idx.append(idx)

            domain_desc, example_prompt, cot_prompt, action_idx = self.search_db_file(dataset_name, idx, action_headers)
            
            ######## return the number 1 idx and number 2 idx ##########
            best_result['domain_desc'].append(domain_desc)
            best_result['example_prompt'].append(example_prompt)
            best_result['cot_prompt'].append(cot_prompt)
            best_result['action_idx'].append(action_idx)
            best_result['action_nl_desc'].append(action_keys[idx])


            if not fine_with_llm:
                if len(best_result['domain_desc']) >= 2:
                    return best_result
            else:
                if len(best_result['domain_desc']) >= 10:
                    break

        if fine_with_llm:
            nl_candidate = [action_keys[id] for id in best_result_idx]
            llm_rerank_prompt, idx_map = llm_reranker_prompt(query, nl_candidate, best_result_idx)
            _, llm_output = self.get_response(llm_rerank_prompt, max_retry=3, verbose=True)
            llm_output = llm_output.strip()
            # print(f"[LLM Rerank Output]: {llm_output}")

            if llm_output == "-1" or llm_output == -1:
                print("[LLM Rerank]: No relevant actions found. Return the best results ranked by model")
                return best_result
            else:
                try:
                    
                    ranks = [int(x.strip()) for x in llm_output.split(',')]
                    rerank_action_idx = [idx_map[x] for x in ranks if x in idx_map]
                    
                    ### rewrite best result with the rerank action idx
                    best_result = {'domain_desc': [], 'example_prompt': [], 'cot_prompt': [], 'action_idx': [], 'action_nl_desc': []}
                    for rk in rerank_action_idx:
                        domain_desc, example_prompt, cot_prompt, action_idx = self.search_db_file(dataset_name, rk, action_headers)
                
                        ######## return the number 1 idx and number 2 idx ##########
                        best_result['domain_desc'].append(domain_desc)
                        best_result['example_prompt'].append(example_prompt)
                        best_result['cot_prompt'].append(cot_prompt)
                        best_result['action_idx'].append(action_idx)

                    text_idx = [int(x.strip()) - 1 for x in llm_output.split(',')]
                    print("\nAfter rerank, top 1 is:")
                    # for i in text_idx:
                    #     print(f"- {nl_candidate[i]}")
                    best_result['action_nl_desc'].append(nl_candidate[text_idx[0]])
                    print(f"- {nl_candidate[text_idx[0]]}")

                    return best_result
                    
                except Exception as e:
                    print("llm output format wrong:", e)

        
        return None
            


def is_llm_alive(engine):
    llm_gpt = GPT_Chat(engine=engine)
    _, llm_output = llm_gpt.get_response('just say the word "hello" to me with no "!"')
    # _, llm_output = llm_gpt.get_response('introduce yourself in one sentence')
    print(llm_output)



def test_find_best_action(query, current_domain_name, llm_method='minilm', fine_with_llm=False, nl_query=None):
    llm_gpt = GPT_Chat(engine='gpt-4.1-nano-2025-04-14')
    
    if llm_method == 'ada':
        action_lib_embed_path = "prompts\cached_action_embeddings_openai.npz"
    elif llm_method == 'minilm':
        action_lib_embed_path = "prompts/cached_action_embeddings_minilm.npz"

    best_result = llm_gpt.find_best_action_domain(query, current_domain_name, 
                                                  action_lib_embed_path, 
                                                  llm_method, top_k=20, fine_with_llm=fine_with_llm, 
                                                  nl_query=nl_query)
    
    # print(best_result)


def test_all_action_in_db():
    dataset_root = 'uav_domain_benchmark'
    for dataset_domain in os.listdir(dataset_root):
        if dataset_domain == 'BlockWorld' or dataset_domain == ".git" or dataset_domain == ".gitignore" or dataset_domain == "README.md":
            continue
        current_domain_name = dataset_domain

        with open(os.path.join(dataset_root, dataset_domain, 'action_desc.json'), 'r', encoding='utf-8') as f:
            action_desc = json.load(f)
            print(f"Domain: {dataset_domain}")
            for action_name, action_info in action_desc.items():
                print(f"  Action: {action_name}")
                print(f"    Description: {action_info['desc']}")
                print(f"    Abstract Description: {action_info['abstract_desc']}")

                query = action_info['abstract_desc']
                test_find_best_action(query, current_domain_name, llm_method='minilm')

                print("" + "=" * 50 + "\n")
                print("" + "=" * 50 + "\n")
                print("" + "=" * 50 + "\n")



if __name__ == '__main__':
    abs_query = "This action enables the uav to move from [position1] to [position2] while accelerating [value1] by [value2], if [position1] is marked as [state1] and [position1] and [position2] are [state2]."
    nl_query = "This action enables the uav to move from one position to the next connected position while accelerating its current speed by the acceleration rate. The current position must be marked as passable. For example, if uav is at position_1, the position_1 is connected to position_2, if the position_1 is marked as passable, then the uav can move from position_1 to position_2. The current speed is increased by the acceleration rate."
    current_domain_name = "SpeedAdapt"

    
    #test_find_best_action(abs_query, current_domain_name, llm_method='minilm', fine_with_llm=True, nl_query=nl_query)
    # test_find_best_action(abs_query, current_domain_name, llm_method='minilm', fine_with_llm=True, nl_query=nl_query)
    # test_all_action_in_db()

    # is_llm_alive('deepseek-chat')
    
