; test start-cooking - finish-cooking
(define (problem meal-1)
  (:domain uav_meal_delivery)
  (:objects
    a1 - arm
    m1 - meal
    l1 - location
  )
  (:init
    (at-arm a1 l1)
    (not (prepared m1))
  )
  (:goal
    (and
      (prepared m1)
      (at-meal m1 l1)
    )
  )
)
