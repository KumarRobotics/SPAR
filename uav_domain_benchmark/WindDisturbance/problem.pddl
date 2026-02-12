(define (problem WindDistProb) (:domain WindDist)
(:objects 
    uav - uav
    p0 p1 p2 p3 p4 p5 p6 p7 p8 - position
)

(:init
    ;todo: put the initial state's facts and numeric values here
    (at uav p2)
    (connect p0 p1)
    (connect p0 p2)
    (connect p1 p5)
    (connect p2 p7)
    (connect p3 p2)
    (connect p3 p8)
    (connect p3 p6)
    (connect p4 p3)
    (connect p5 p3)
    (connect p6 p5)
    (connect p6 p8)
    (connect p7 p4)
    (connect p8 p4)
    (= (cost) 0)

    (wind p2)
    (wind p4)
    (wind p6)
    (blow-to p2 p4)
    (blow-to p4 p1)
    (blow-to p6 p5)
)

(:goal (and
    ;todo: put the goal condition here
    (at uav p8)
))

;un-comment the following line if metric is needed
(:metric minimize (cost))
)
