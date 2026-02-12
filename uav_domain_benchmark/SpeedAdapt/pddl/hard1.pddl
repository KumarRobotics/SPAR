(define (problem SpeedAdaptProb) (:domain SpeedAdapt)
(:objects 
uav - uav
p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 - position
)

(:init
    ;todo: put the initial state's facts and numeric values here
    (at uav p1)

    (is-pass p1)
    (is-pass p3)
    (is-pass p4)
    (is-pass p8)  ;;; have to define the state
    (is-pass p6)
    (is-pass p7)
    (is-pass p8)
    (is-pass p10)
    (is-clutter p2)
    (is-open-area p5)
    (is-narrow-gap p9)

    (next p1 p2)
    (next p2 p3)
    (next p3 p4)
    (next p4 p5)
    (next p5 p6)
    (next p6 p7)
    (next p7 p8)
    (next p8 p9)
    (next p9 p10)

    (= (acc uav) 3)
    (= (speed uav) 5)
    (= (clutter-speed) 3)
    (= (narrow-gap-speed) 4)
    (= (open-area-speed) 6)
)

(:goal (and
    ;todo: put the goal condition here
    (at uav p10)
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
