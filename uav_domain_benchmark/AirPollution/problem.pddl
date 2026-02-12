(define (problem AirQualityMonitoringProblem1) (:domain AirQualityMonitoring)
(:objects 
    drone - uav
    region1 region2 region3 - region
)

(:init
    ;todo: put the initial state's facts and numeric values here
    (at drone region1)
    
    (next region1 region2)
    (next region2 region3)
    (next region3 region1)

    (= (need-time region1) 3)
    (= (need-time region2) 2)
    (= (need-time region3) 4)
    (= (spend-time region1) 0)
    (= (spend-time region2) 0)
    (= (spend-time region3) 0)
)

(:goal (and
    ;todo: put the goal condition here
    (= (spend-time region1) (need-time region1))
    (= (spend-time  region2) (need-time region1))
    (= (spend-time  region3) (need-time region1))
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
