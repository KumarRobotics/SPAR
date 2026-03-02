# SPAR: Scalable LLM-based PDDL Domain Generation for Aerial Robotics


## About

 SPAR is a framework that leverages the generative capabilities of LLMs to automatically produce valid, diverse, and semantically accurate PDDL domains from natural language input.

__Authors__: [Songhao Huang](https://scholar.google.com/citations?user=agLfnDmqINkC) *, [Yuwei Wu](https://github.com/yuwei-wu) *, 
[Guangyao Shi](https://guangyaoshi.github.io/), [Gaurav S. Sukhatme](https://uscresl.org/principal-investigator/), and [Vijay Kumar](https://www.kumarrobotics.org/)

__Related Paper__: Songhao Huang*, Yuwei Wu*, Guangyao Shi, Gaurav S. Sukhatme, and Vijay Kumar. "SPAR: Scalable LLM-based PDDL Domain Generation for Aerial Robotics." [arxiv Preprint](https://arxiv.org/pdf/2509.13691)

If this repo helps your research, please cite our paper at:

```bibtex
@article{huang2025spar,
  title={SPAR: Scalable LLM-based PDDL Domain Generation for Aerial Robotics},
  author={Huang, Songhao and Wu, Yuwei and Shi, Guangyao and Sukhatme, Gaurav S and Kumar, Vijay},
  journal={arXiv preprint arXiv:2509.13691},
  year={2025}
}
```


## Framework

<p align="center">
  <img src="docs/framework.png"/>
</p>


## Repository Layout

- `action_gen.py`: generate a PDDL domain for one benchmark domain.
- `eval_syntax.py`: run domain-generation experiments and aggregate syntax error counts.
- `problem_gen.py`: generate PDDL problem files compatible with generated domains.
- `batch_solve.py`: solve generated domain/problem pairs with ENHSP.
- `eval/domain_similarity.py`: validate plans against generated domains with VAL.
- `pddl_validator.py`: syntax and semantic checks used during iterative correction.
- `llm_model.py`: model wrapper, embedding lookup, and retrieval utilities.
- `planner/`: ENHSP wrapper plus the bundled `enhsp-20.jar`.
- `prompts/`: prompt templates, retrieval assets, and embedding-cache scripts.
- `uav_domain_benchmark/`: benchmark and dataset for UAV task-planning domains.

## Requirements

- Python 3.10+
- Java 17+ available as `java`, or set `JAVA_BIN`
- At least one model API key:
  - `OPENAI_API_KEY` for OpenAI models
  - `DEEPSEEK_API_KEY` for DeepSeek models
- Local sentence-transformer checkpoint for retrieval:
  - `local_model/all-mpnet-base-v2`

Optional:

- `VAL_BIN` for `eval/domain_similarity.py`
- `local_model/bge-reranker-v2-m3` for regenerating BGE retrieval caches

Install dependencies:

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Set the environment variables you need:

```bash
export OPENAI_API_KEY=your_key_here
export DEEPSEEK_API_KEY=your_key_here
export JAVA_BIN=java
export VAL_BIN=/path/to/Validate
```

## Quick Start

### 1. Generate one domain

Edit the variables in the `__main__` block of `action_gen.py`:

- `_domain_name_str`
- `_engine`
- `_prompt_method`
- `_result_log_dir`

Then run:

```bash
python action_gen.py
```

Outputs include the generated domain, intermediate LLM transcripts, extracted predicates/functions, and validation error counts.

### 2. Run syntax evaluation

`eval_syntax.py` has two entry paths:

- `syntax_eval()` to generate domains and log validation errors
- `total_error_count()` to aggregate existing results

Before running, edit the module-level settings in `eval_syntax.py`, especially:

- `engine_list`
- `prompt_method_restart_list`
- `restart_domain`
- `restart_method`
- `restart_engine`

Then run:

```bash
python eval_syntax.py
```

Results are written under `results/<timestamp>/<engine>/<domain>/<prompt_method>/`.

### 3. Generate problems for generated domains

`problem_gen.py` expects generated domains to already exist under `results/`. Update the module-level variables near the top of the file:

- `date_str`
- `engine`
- `gpt_engine`
- restart controls such as `restart_domain`, `restart_method`, and `restart_problem`

Then run:

```bash
python problem_gen.py
```

Generated problems are written under:

```text
results/<date_str>/<engine>/<domain>/<prompt_method>/pddl/
```

### 4. Solve with ENHSP

Edit the module-level configuration in `batch_solve.py`:

- `date_str`
- `engine`
- `prompt_method_restart_list`
- optional restart filters such as `restart_domain`

Then run:

```bash
python batch_solve.py
```

The script writes `.plan` files next to generated problems and prints per-method success rates.

### 5. Validate plans with VAL

`eval/domain_similarity.py` compares generated plans and generated domains using VAL.

Requirements:

- source plans in the benchmark domain folders under `uav_domain_benchmark/<domain>/pddl/*.plan`
- generated domains and problems under `results/`
- `VAL_BIN` pointing to the `Validate` executable

Edit the module-level variables in `eval/domain_similarity.py`, then run:

```bash
python eval/domain_similarity.py
```

### 6. Regenerate retrieval embeddings

If you need to rebuild the retrieval cache, update the options in `prompts/save_action_embed.py` and run:

```bash
python prompts/save_action_embed.py
```

This only requires `OPENAI_API_KEY` when the script is configured with `use_llm=True`.

## Acknowledgements

- [ENHSP](https://sites.google.com/view/enhsp/): planner-based evaluation of generated domain and problem pairs.
- [VAL](https://github.com/KCL-Planning/VAL): plan validation.
- [all-mpnet-base-v2](https://huggingface.co/sentence-transformers/all-mpnet-base-v2): retrieval-based prompting and action similarity search.
- [OpenAI API](https://platform.openai.com/docs/overview) and [DeepSeek API](https://api-docs.deepseek.com/)



## Maintaince

For any technical issues, please contact Yuwei Wu (yuweiwu@seas.upenn.edu, yuweiwu20001@outlook.com).
