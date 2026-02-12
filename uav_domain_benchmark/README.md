# uav_domain_benchmark
A benchmark of UAV task-planning domains in PDDL, with natural-language descriptions and structured action metadata.


## 1. Format
All the domains and corresponding problems are formulated in PDDL format and tested using a task planning solver.

### Domain Categories in SPAR

| Category           | Domains |
|-------------------|----------|
| Navigation        | 2DNavigation, HouseNavigation, MultiCamLand, SimpleNavigation |
| Transportation    | AirPassenger, CityCargo, Delivery, DeliveryCapacity, DeliveryDurative, DeliveryPriority, MedsDelivery, MedsDeliveryEnergy, MealDelivery |
| Manipulation      | BlockWorld, CeilingPaint, GraspDelivery, GraspFruit, Watering |
| Monitoring        | AirPollution, ForestFireCollaboration, MaintenanceComponent, MovableObs |
| Exploration       | GridExplore, MarsExploration |
| Aerial Operations | Gate, Landing, Perching, Tracking, WindDisturbance |
| Adaptation        | TerrainAdapt, SpeedAdapt |


### Dataset Contents

Each domain folder follows a consistent structure:
- `pddl/domain.pddl` (domain definition)
- `pddl/*.pddl` or `problem.pddl` (problem instances)
- `domain_desc.txt` (natural-language domain description)
- `action_desc.json` (structured action descriptions)
- `domain_example_prompt.txt` and `cot_prompt.txt` (prompting artifacts)
- `hierarchy_requirements.json` (hierarchy constraints)
- `source.txt` (domain provenance, when available)


## 2. Contribute
Before adding a new domain, the folder must contain: 
- A pddl domain file
- A pddl problem file
- A source for this domain(maybe from papers/websites/...)
- can work   

It'd be better to include:
- A domain description in Natural language
- A action description in .json format
- A problem description in Natural language
