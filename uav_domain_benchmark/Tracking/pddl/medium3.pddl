(define (problem TrackingProb) 
    (:domain trackingdomain)

    (:objects 
        uav - uav
        p0 p1 p2 p3 p4 p5 p6 p7 p8 p9 - position
    )

    (:init
    
        ; UAV movement constraints
        (next-uav p0 p1)
        (next-uav p1 p2)
        (next-uav p1 p5)
        (next-uav p2 p3)
        (next-uav p3 p7)
        (next-uav p5 p4)
        (next-uav p5 p8)
        (next-uav p8 p7)
        (next-uav p7 p5)
        (next-uav p7 p9)

        (next-goal p0 p1)
        (next-goal p1 p5)
        (next-goal p5 p9)

        (current-goal p0)
        (at uav p0)
        
    )

    (:goal (and
        (reach-subgoal p1)
        (reach-subgoal p5)
        (at uav p9)
    ))

    ; Uncomment if a metric is needed
    (:metric minimize (cost))
)