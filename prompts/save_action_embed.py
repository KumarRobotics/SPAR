#######################   save all the actions in the action lib to embeddings, save time!   #######################
import os
import numpy as np
from openai import OpenAI
import json
from sentence_transformers import SentenceTransformer
from template_generator import generate_abs_action_desc_prompt
import openai


#model_minilm = SentenceTransformer("local_model\models--sentence-transformers--all-MiniLM-L6-v2\snapshots\c9745ed1d9f207416be6d2e6f8de32d1f16199bf")
model_minilm = SentenceTransformer("./local_model/all-mpnet-base-v2")  # Using a more recent model for better performance
model_bge = SentenceTransformer('./local_model/bge-reranker-v2-m3')  # BGE model for reranking
openai.api_key = os.environ.get("OPENAI_API_KEY")


def save_action_embeddings(query, model="minilm", use_llm=False, output_npz=False):

    """
    1. save all the action embeddings to a file
    2. using different models to generate embeddings
    3. if use_llm is True, the query should be a natural language description of the action, 
        otherwise it should be a abstract description
    """

    action_lib_path = "prompts\\action_lib.json"

    with open(action_lib_path, "r", encoding="utf-8") as f:
        action_desc_map = json.load(f)

    action_keys = list(action_desc_map.keys())
    dataset_name = [v[0] for v in action_desc_map.values()]
    action_name_in_pddl = [v[1] for v in action_desc_map.values()]
    action_headers = [v[2] for v in action_desc_map.values()]
    abs_action_desc = [v[3] for v in action_desc_map.values()]
    all_descriptions = [key for key in action_keys]  


    if use_llm:
        if not openai.api_key:
            raise RuntimeError("Missing required environment variable: OPENAI_API_KEY")
        ### put the query into the end of action lib list
        template = generate_abs_action_desc_prompt(query)
        response = openai.chat.completions.create(
            model="gpt-4.1-2025-04-14",  # or "gpt-4"
            messages=[{"role": "user", "content": template}],
            temperature=0,
        )

        query_abs = response.choices[0].message.content.strip()
    else:
        query_abs = query

    print(query_abs)

    query_embedding = model_minilm.encode(query_abs)
    embeddings = model_minilm.encode(abs_action_desc, show_progress_bar=True)
    similarity_matrix = model_minilm.similarity(query_embedding, embeddings)

    print(similarity_matrix.shape)
    print(similarity_matrix)

    similarity_matrix = similarity_matrix.cpu().numpy().flatten()
    sorted_indices = np.argsort(similarity_matrix)[::-1]

    ### output the top 5 most similar actions
    for i in range(5):
        print("" + "=" * 50 + "\n")
        idx = sorted_indices[i]
        print(f"[{i + 1}] similarity: {similarity_matrix[idx]:.4f}")
        print(f" Action header: {action_headers[idx]}")
        print(f" {action_keys[idx]}")
        print(f" Found in datasets: {dataset_name[idx]}")
        print(f" Action name in PDDL: {action_name_in_pddl[idx]}")
        print(f" Action description: {all_descriptions[idx]}")
    
    if output_npz:

        save_path = f"prompts/cached_action_embeddings_{model}.npz"
        np.savez(save_path,
                embeddings=np.array(embeddings),
                keys=np.array(action_keys),
                dataset_name=np.array(dataset_name),
                action_name_in_pddl=np.array(action_name_in_pddl),
                action_headers=np.array(action_headers),
                abs_action_desc = np.array(abs_action_desc))

        print(f"Embeddings cached to 'cached_action_embeddings_{model}.npz'")




if __name__ == '__main__':
    query = "This action enables the uav to mark [variable1] as [variable2] if [variable2] has [variable3] and the uav is at [variable2]."
    save_action_embeddings(query, model="minilm", use_llm=False, output_npz=True)  # Using MiniLM for embeddings
