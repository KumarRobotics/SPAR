; more complex map
(define (problem nav-prob-5)
  (:domain uav-navigation)
  (:objects u1 - uav l1 l2 l3 l4 l5 - location)
  (:init
    (at-uav u1 l1)
    (next-location l1 l2) (next-location l2 l1)
    (next-location l2 l3) (next-location l3 l2)
    (next-location l2 l4) (next-location l4 l2)
    (next-location l3 l5) (next-location l5 l3)
  )
  (:goal (goal-reached u1 l5))
)
