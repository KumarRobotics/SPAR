(define (problem speedadapt-simple-open)
  (:domain SpeedAdapt)
  (:objects
    u1 - uav
    p1 - position
  )
  (:init
    (at u1 p1)
    (is-narrow-gap p1)
    (= (speed u1) 0.1)
    (= (acc u1) 1)
    (= (narrow-gap-speed) 2)
  )
  (:goal (and (is-pass p1)))
)