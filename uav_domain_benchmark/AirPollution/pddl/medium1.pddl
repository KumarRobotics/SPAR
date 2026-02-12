; multiple region, 
(define (problem medium-monitor-two-goals)
  (:domain AirQualityMonitoring)

  (:objects
    u1 - uav
    r1 r2 r3 r4 - region
  )

  (:init
    (at u1 r1)
    (next r1 r2)
    (next r2 r3)
    (next r3 r4)

    (= (need-time r3) 2)
    (= (spend-time r3) 0)
    (= (need-time r4) 3)
    (= (spend-time r4) 0)
  )

  (:goal
    (and
      (= (spend-time r3) (need-time r3))
      (= (spend-time r4) (need-time r4))
    )
  )
)
