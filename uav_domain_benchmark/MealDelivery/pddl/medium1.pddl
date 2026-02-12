(define (problem meal-6)
  (:domain uav_meal_delivery)
  (:objects
    a1 - arm
    u1 - uav
    m1 m2 - meal
    l1 l2 - location
  )
  (:init
    (at-arm a1 l1)
    (at-uav u1 l1)
    (empty-uav u1)
  )
  (:goal
    (and
      (at-meal m1 l2)
      (at-meal m2 l2)
    )
  )
)
