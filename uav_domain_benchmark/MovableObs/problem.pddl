(define (problem MovableObsProb) (:domain MovableObs)
(:objects 
 u1 - uav
 g1 - ugv
 p1 p2 p3 p4 p5 p6 p7 p8 - position
)

(:init
    ;todo: put the initial state's facts and numeric values here
    (at-uav u1 p1)
    (at-ugv g1 p1)
    (= (cost) 0)
    (connect p1 p2)
    (connect p1 p3)
    (connect p1 p4)

    (connect p2 p1)
    (connect p2 p3)
    (connect p2 p5)
    (connect p2 p6)

    (connect p3 p1)
    (connect p3 p2)
    (connect p3 p6)

    (connect p4 p1)
    (connect p4 p6)

    (connect p5 p2)
    (connect p5 p8)
    (connect p5 p7)

    (connect p6 p3)
    (connect p6 p2)
    (connect p6 p4)
    (connect p6 p7)

    (connect p7 p5)
    (connect p7 p6)

    (connect p8 p5)

    (clear p1)
    (clear p5)
    (clear p7)
    (clear p8)
    (mov-obs p2)
    (mov-obs p3)
    (mov-obs p4)
    (fix-obs p6)
)

(:goal (and
    ;todo: put the goal condition here
    (at-ugv g1 p7)
))

;un-comment the following line if metric is needed
(:metric minimize (cost))
)
