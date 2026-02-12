(define (problem meal-8)
  (:domain uav_meal_delivery)
  (:objects
    a1 a2 - arm
    u1 - uav
    m1 m2 - meal
    l1 l2 l3 l4 - location
  )
  (:init
    (at-arm a1 l1) (at-arm a2 l2)
    (at-uav u1 l1)
    (empty-uav u1)
  )
  (:goal
    (and
      (at-meal m1 l4)
      (at-meal m2 l3)
    )
  )
)
