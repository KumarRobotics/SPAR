; test pick-up-meal - deliver-meal 
(define (problem meal-3)
  (:domain uav_meal_delivery)
  (:objects
    u1 - uav
    m1 - meal
    l1 l2 - location
  )
  (:init
    (at-uav u1 l1)
    (at-meal m1 l1)
    (prepared m1)
    (empty-uav u1)
  )
  (:goal
    (at-meal m1 l2)
  )
)
