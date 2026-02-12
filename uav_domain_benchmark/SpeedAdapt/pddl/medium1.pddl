(define (problem speedadapt-simple-open)
  (:domain SpeedAdapt)
  (:objects
    u1 - uav
    p1 p2 - position
  )
  (:init
    (at u1 p1)
    (next p1 p2)
    (is-pass p1)
  )
  (:goal (and (at u1 p2)))
)