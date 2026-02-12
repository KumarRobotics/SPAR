; test fly
(define (problem landing-prob-3)
  (:domain UAV-Landing)
  (:objects u1 - uav l1 l2 - location)
  (:init
    (at u1 l1)
    (in-air u1)
    (connected l1 l2)
    (connected l2 l1)
  )
  (:goal (at u1 l2))
)
