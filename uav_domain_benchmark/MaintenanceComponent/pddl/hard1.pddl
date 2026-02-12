; 4 components
(define (problem uav_maintenance_problem) (:domain uav_maintenance)
(:objects 
    uav - uav
    c1 c2 c3 c4 - component
)

(:init
    ;todo: put the initial state's facts and numeric values here
    (available uav)
    (= (max_heat) 4)
    (= (heat c1) 3)
    (= (heat c2) 5)
    (= (heat c3) 10)
    (= (heat c4) 2)
    (bad-state c2)
    (bad-state c4)
)

(:goal (and
    ;todo: put the goal condition here
    (heat_analyzed c1) 
    (image_analyzed c1)
    (heat_analyzed c2) 
    (image_analyzed c2)
    (heat_analyzed c3) 
    (image_analyzed c3)
    (heat_analyzed c4) 
    (image_analyzed c4)
))

)
