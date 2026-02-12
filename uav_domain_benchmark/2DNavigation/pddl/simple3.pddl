; simple problem 2, only test move and reach-goal on a simple map

(define (problem NavProblem3) (:domain NavDomain)
(:objects 
    uav1 - uav
    p0 p1 p2 p3 p4 p5 p6 p7 p8 - position
)

(:init
    ;todo: put the initial state's facts and numeric values here
    (at uav1 p0)
    (connect p0 p1)
    (goal p1)
    
    (= (cost) 0)
)

(:goal (and
    ;todo: put the goal condition here
    (finish)
))

;un-comment the following line if metric is needed
(:metric minimize (cost))
)
