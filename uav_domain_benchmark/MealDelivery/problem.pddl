(define (problem uav_meal_delivery_prob) (:domain uav_meal_delivery)
(:objects 
    uav1 - uav
    ice-cream rice noodles fry-rice - meal
    kitchen table house1 house2 house3 house4 - location
    arm1 arm2 - arm
)

(:init
    (at-uav uav1 kitchen)
    (at-arm arm1 kitchen)
    (at-arm arm2 table)


    (empty-uav uav1)
    
)


(:goal (and
    ;todo: put the goal condition here
    (at-meal ice-cream house1)
    (at-meal noodles house2)
    (at-meal fry-rice house3)
    (at-meal rice house4)
))

)
