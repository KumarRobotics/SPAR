(define (problem TerrainAdaptProb) (:domain TerrainAdapt)
(:objects 
  uav - uav
  p1 p2 p3 p4 p5 p6 - position
)

(:init
    ;todo: put the initial state's facts and numeric values here
    (at uav p1)
    (bad-weather p2)
    (slippery-road p3)
    (bad-weather p5)
    (fly-mode uav)

    (next p1 p2)
    (next p2 p3)
    (next p3 p4)
    (next p4 p5)
    (next p5 p6)
)

(:goal (and
    ;todo: put the goal condition here
    (at uav p6)
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
