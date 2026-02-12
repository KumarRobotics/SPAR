; test move action
(define (problem simple-move)
  (:domain AirQualityMonitoring)

  (:objects
    u1 - uav
    r1 r2 r3 - region
  )

  (:init
    (at u1 r1)
    (next r1 r2)
    (next r1 r3)

  )

  (:goal
    (at u1 r2)
  )
)
