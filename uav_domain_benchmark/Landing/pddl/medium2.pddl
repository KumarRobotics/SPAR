; test fly check land
(define (problem landing-prob-5)
  (:domain UAV-Landing)
  (:objects u1 - uav l1 l2 - location)
  (:init
    (at u1 l1)
    (in-air u1)
    (connected l1 l2) (connected l2 l1)
    (clear l2)
  )
  (:goal (landed u1))
)
