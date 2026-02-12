(define (problem meal-7)
  (:domain uav_meal_delivery)
  (:objects
    a1 a2 - arm
    u1 u2 - uav
    m1 m2 - meal
    l1 l2 - location
  )
  (:init
    (at-arm a1 l1) (at-arm a2 l1)
    (at-uav u1 l1) (at-uav u2 l1)
    (empty-uav u1) (empty-uav u2)
  )
  (:goal
    (and
      (at-meal m1 l2)
      (at-meal m2 l2)
    )
  )
)
