; test move
(define (problem nav-prob-1)
  (:domain uav-navigation)
  (:objects u1 - uav l1 l2 - location)
  (:init
    (at-uav u1 l1)
    (next-location l1 l2)
    (next-location l2 l1)
  )
  (:goal (at-uav u1 l2))
)
