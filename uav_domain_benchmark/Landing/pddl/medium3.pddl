; test all actions
(define (problem landing-prob-6)
  (:domain UAV-Landing)
  (:objects u1 - uav l1 l2 l3 - location)
  (:init
    (at u1 l1)
    (in-air u1)
    (connected l1 l2) (connected l2 l1)
    (connected l2 l3) (connected l3 l2)
    (clear l3)
  )
  (:goal (landed u1))
)
