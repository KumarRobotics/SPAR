(define (problem speedadapt-acc-open)
  (:domain SpeedAdapt)
  (:objects
    u1 - uav
    p1 p2 - position
  )
  (:init
    (at u1 p1)
    (next p1 p2)
    (is-pass p1)
    (is-open-area p2)
    (= (speed u1) 1)
    (= (acc u1) 1)
    (= (open-area-speed) 2)
  )
  (:goal (and (is-pass p2)))
)