; simple problem 2, only test the action reach-goal
(define (problem NavProblem2) (:domain NavDomain)
(:objects 
    uav1 - uav
    p0 p1 p2 p3 p4 p5 p6 p7 p8 - position
)

(:init
    ;todo: put the initial state's facts and numeric values here
    (at uav1 p0)
    (goal p0)
    
    (= (cost) 0)
)

(:goal (and
    ;todo: put the goal condition here
    (finish)
))

;un-comment the following line if metric is needed
(:metric minimize (cost))
)
