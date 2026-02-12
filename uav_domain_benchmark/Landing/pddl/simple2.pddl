; test land
(define (problem landing-prob-2)
  (:domain UAV-Landing)
  (:objects u1 - uav l1 - location)
  (:init
    (at u1 l1)
    (in-air u1)
    (landing-spot l1)
  )
  (:goal (landed u1))
)
