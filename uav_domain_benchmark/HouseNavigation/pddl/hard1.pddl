; 2 uav, different goals
(define (problem nav-prob-7)
  (:domain uav-navigation)
  (:objects u1 u2 - uav l1 l2 l3 l4 - location)
  (:init
    (at-uav u1 l1)
    (at-uav u2 l4)
    (next-location l1 l2) (next-location l2 l1)
    (next-location l2 l3) (next-location l3 l2)
    (next-location l3 l4) (next-location l4 l3)
  )
  (:goal (and
    (goal-reached u1 l3)
    (goal-reached u2 l1)
  ))
)
