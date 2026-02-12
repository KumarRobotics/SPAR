; more complex map
(define (problem nav-prob-4)
  (:domain uav-navigation)
  (:objects u1 - uav l1 l2 l3 - location)
  (:init
    (at-uav u1 l1)
    (next-location l1 l2)
    (next-location l2 l1)
    (next-location l2 l3)
    (next-location l3 l2)
  )
  (:goal (goal-reached u1 l3))
)
