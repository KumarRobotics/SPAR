(define (problem FORESTFIREUAVUGV) (:domain ForestFireCollabration)
(:objects 
    drone - uav
    car - ugv
    area_1 area_2 area_3 base - area
)

(:init
    ;todo: put the initial state's facts and numeric values here
    
    (next area_1 area_2)
    (next area_2 area_3)
    (next area_3 area_1)
    (next base area_1)
    (at-uav-location drone base)
    (at-ugv-location car base)
    (on-fire area_2)
    (on-fire area_3)
)

(:goal (and
    ;todo: put the goal condition here
    (not(on-fire area_2))
    (not(on-fire area_3))
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
