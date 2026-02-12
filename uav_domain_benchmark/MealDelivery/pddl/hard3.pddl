(define (problem meal-9)
  (:domain uav_meal_delivery)
  (:objects
    a1 a2 a3 - arm
    u1 u2 u3 - uav
    m1 m2 m3 - meal
    l1 l2 l3 l4 l5 l6 - location
  )
  (:init
    (at-arm a1 l1) (at-arm a2 l2) (at-arm a3 l3)
    (at-uav u1 l1) (at-uav u2 l2) (at-uav u3 l3)
    (empty-uav u1) (empty-uav u2) (empty-uav u3)
  )
  (:goal
    (and
      (at-meal m1 l4)
      (at-meal m2 l5)
      (at-meal m3 l6)
    )
  )
)
