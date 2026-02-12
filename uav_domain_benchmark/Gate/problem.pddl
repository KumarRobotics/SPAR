(define (problem GateProb) (:domain Gate)
(:objects 
    u - uav
)

(:init
    ;todo: put the initial state's facts and numeric values here
    (= (cur_angel u) 0)
    (= (control_rate u) 2)
    (= (gate_angle) 10)
)

(:goal (and
    ;todo: put the goal condition here
    (pass u)
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
