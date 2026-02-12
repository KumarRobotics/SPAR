; test fly land
(define (problem landing-prob-4)
  (:domain UAV-Landing)
  (:objects u1 - uav l1 l2 - location)
  (:init
    (at u1 l1)
    (in-air u1)
    (connected l1 l2) (connected l2 l1)
    (landing-spot l2)
  )
  (:goal (landed u1))
)
