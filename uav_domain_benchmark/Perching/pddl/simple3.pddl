(define (problem perch-simple-3)
  (:domain UAV-Perching)
  (:objects u1 - uav l1 - location)
  (:init
    (at u1 l1)
    (perched u1)
  )
  (:goal (and
    (in-air u1)
  ))
)
