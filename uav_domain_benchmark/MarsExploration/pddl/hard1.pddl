(define (problem MarsExplorationProblem) (:domain MarsExplorationDomain)
(:objects 
    uav - uav
    rov - rover
    base loc1 loc2 loc3 loc4 - location
)

(:init
    ;todo: put the initial state's facts and numeric values here
    (at-uav uav base)
    (at-rov rov base)
    (resource loc1)
    (resource loc2)
    (resource loc4)
    (= (value base) 0)
    (= (value loc1) 10)
    (= (value loc2) 20)
    (= (value loc3) 0)
    (= (value loc4) 30)
    (= (total-resource) 0)
)

(:goal (and
    ;todo: put the goal condition here

    (resource-collected loc1)
    (resource-collected loc2)
    (resource-collected loc4)
))

;un-comment the following line if metric is needed
 (:metric maximize (total-resource))

)
