(define (problem speedadapt-chain)
  (:domain SpeedAdapt)
  (:objects
    u1 - uav
    p1 p2 p3 p4 - position
  )
  (:init
    (at u1 p1)
    (is-pass p1)
    (next p1 p2)
    (next p2 p3)
    (next p3 p4)
    
    (is-open-area p1)
    (is-clutter p2)
    (is-narrow-gap p3)
    (is-open-area p4)
    (= (speed u1) 1)
    (= (acc u1) 1)
    (= (open-area-speed) 3)
    (= (clutter-speed) 2)
    (= (narrow-gap-speed) 2)
  )
  (:goal (and (at u1 p4)))
)