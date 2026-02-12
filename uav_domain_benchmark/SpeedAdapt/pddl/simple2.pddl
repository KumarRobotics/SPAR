(define (problem speedadapt-simple-open)
  (:domain SpeedAdapt)
  (:objects
    u1 - uav
    p1 - position
  )
  (:init
    (at u1 p1)
    (is-open-area p1)
    (= (speed u1) 3)
    (= (acc u1) 1)
    (= (open-area-speed) 2)
  )
  (:goal (and (is-pass p1)))
)