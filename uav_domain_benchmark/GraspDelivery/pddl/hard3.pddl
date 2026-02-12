; one uav one package
(define (problem GraspDeliveryProb) (:domain GraspDelivery)
(:objects 
    u - uav
    p - package
    p0 p1 p2 p3 p4 p5 p6 p7 p8 - location
)

(:init
    ;todo: put the initial state's facts and numeric values here
    (next p0 p1)
    (next p0 p2)
    (next p1 p5)
    (next p2 p7)
    (next p3 p2)
    (next p3 p8)
    (next p3 p6)
    (next p4 p3)
    (next p5 p3)
    (next p6 p5)
    (next p6 p8)
    (next p7 p4)
    (next p8 p4)

    (at u p0)

    (at p p5)

    (narrow-gap p1)
    (narrow-gap p3)
)

(:goal (and
    ;todo: put the goal condition here
    (at p p8)
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
