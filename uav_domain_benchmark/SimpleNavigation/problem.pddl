(define (problem SimpleNavigationProblem) (:domain SimpleNavigationDomain)
(:objects 
    uav - uav
    location_1 location_2 location_3 location_4 - location
)

(:init
    (at-next location_2 location_3)
    (at-next location_3 location_1)
    (at-next location_1 location_4)
    (is-goal location_4)

    (at-location uav location_2)
)

(:goal (and
    (reach-goal uav)
))

)
