; 2 uav 2 land
(define (problem landing-prob-8)
  (:domain UAV-Landing)
  (:objects u1 u2 - uav l1 l2 l3 l4 l5 - location)
  (:init
    (at u1 l1) (in-air u1)
    (at u2 l5) (in-air u2)
    (connected l1 l2) (connected l2 l1)
    (connected l2 l3) (connected l3 l2)
    (connected l3 l4) (connected l4 l3)
    (connected l5 l4) (connected l4 l5)
    (clear l3)
    (clear l4)
  )
  (:goal (and
    (landed u1)
    (landed u2)
  ))
)
