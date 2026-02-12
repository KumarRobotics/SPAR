; test finish-cooking - pick-up-meal
(define (problem meal-2)
  (:domain uav_meal_delivery)
  (:objects
    a1 - arm
    u1 - uav
    m1 - meal
    l1 - location
  )
  (:init
    (at-arm a1 l1)
    (at-uav u1 l1)
    (empty-uav u1)
    (cooking a1 m1)
  )
  (:goal
    (and
      (carrying u1 m1)
    )
  )
)
