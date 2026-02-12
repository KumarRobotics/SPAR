; simple problem 2, only test the action move, move the uav from p0 to p3

(define (problem NavProblem1) (:domain NavDomain)
(:objects 
    uav1 - uav
    p0 p1 p2 p3 p4 p5 p6 p7 p8 - position
)

(:init
    ;todo: put the initial state's facts and numeric values here
    (at uav1 p0)
    (connect p0 p1)
    (connect p1 p2)
    (connect p2 p3)
    
    (= (cost) 0)
)

(:goal (and
    ;todo: put the goal condition here
    (at uav1 p3)
))

;un-comment the following line if metric is needed
(:metric minimize (cost))
)
