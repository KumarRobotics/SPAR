(define (problem p1) (:domain GraspFruit)
(:objects 
uav1 - uav
fruit1 fruit2 fruit3 fruit4 - fruit
location1 location2 location3 - location
gripper1 - gripper
)

(:init
    (at-uav uav1 location1)
    (at-fruit fruit1 location1)
    (at-fruit fruit2 location2)
    (at-fruit fruit3 location1)
    (at-fruit fruit4 location2)
    (empty uav1)

    (rot fruit1)
    (rot fruit2)


    (= (battery-level uav1) 7)
    (= (capacity uav1) 10)
    (= (energy-cost location1 location2) 2)
    (= (energy-cost location2 location3) 3)
    (= (energy-cost location1 location3) 4)
    (= (energy-cost location2 location1) 2)
    (= (energy-cost location3 location1) 3)
    (= (energy-cost location3 location2) 3)

    (charging-spot location2)

)

(:goal (and
    ;todo: put the goal condition here
    (image-taken fruit1)
    (image-taken fruit2)
    (image-taken fruit3)
    (image-taken fruit4)
    (at-fruit fruit3 location3)
    (at-fruit fruit4 location3)
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
