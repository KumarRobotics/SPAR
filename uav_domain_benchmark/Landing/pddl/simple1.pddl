; test check landing spot
(define (problem landing-prob-1)
  (:domain UAV-Landing)
  (:objects u1 - uav l1 - location)
  (:init
    (at u1 l1)
    (in-air u1)
    (clear l1)
  )
  (:goal (landing-spot l1))
)
