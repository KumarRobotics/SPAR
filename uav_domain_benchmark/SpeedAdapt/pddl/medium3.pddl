(define (problem speedadapt-dcc-clutter)
  (:domain SpeedAdapt)
  (:objects
    u1 - uav
    p1 p2 - position
  )
  (:init
    (at u1 p1)
    (next p1 p2)
    (is-pass p1)
    (is-clutter p2)
    (= (speed u1) 3)
    (= (acc u1) 1)
    (= (clutter-speed) 2)
  )
  (:goal (and (is-pass p2)))
)