; two uavs monitoring disjoint areas

(define (problem hard-two-uav-disjoint-areas)
  (:domain AirQualityMonitoring)

  (:objects
    u1 u2 - uav
    r1 r2 r3 r4 r5 r6 - region
  )

  (:init
    (at u1 r1)
    (at u2 r4)

    (next r1 r2)
    (next r2 r3)
    (next r4 r5)
    (next r5 r6)


    (= (need-time r3) 3)
    (= (spend-time r3) 0)

    (= (need-time r5) 2)
    (= (spend-time r5) 1)
    (= (need-time r6) 4)
    (= (spend-time r6) 0)
  )

  (:goal
    (and
      (= (spend-time r3) (need-time r3))
      (= (spend-time r5) (need-time r5))
      (= (spend-time r6) (need-time r6))
    )
  )
)
