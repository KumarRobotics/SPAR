; test 2 uav 2 land spots
(define (problem landing-prob-7)
  (:domain UAV-Landing)
  (:objects u1 u2 - uav l1 l2 l3 l4 - location)
  (:init
    (at u1 l1) (in-air u1)
    (at u2 l4) (in-air u2)
    (connected l1 l2) (connected l2 l1)
    (connected l4 l3) (connected l3 l4)
    (clear l2)
    (clear l3)
  )
  (:goal (and
    (landed u1)
    (landed u2)
  ))
)
