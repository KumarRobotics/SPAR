(define (problem perch-simple-1)
  (:domain UAV-Perching)
  (:objects u1 - uav l1 l2 - location)
  (:init
    (at u1 l1)
    (in-air u1)
    (connected l1 l2)
    (clear l2)
  )
  (:goal (and
    (perch-spot l2)
  ))
)
