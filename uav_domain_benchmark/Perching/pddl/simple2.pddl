(define (problem perch-simple-2)
  (:domain UAV-Perching)
  (:objects u1 - uav l1 - location)
  (:init
    (at u1 l1)
    (in-air u1)
    (clear l1)
  )
  (:goal (and
    (perched u1)
    (perch-visit l1)
  ))
)
