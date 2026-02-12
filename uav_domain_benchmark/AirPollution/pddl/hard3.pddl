; 2 UAVs, monitoring a network topology with specific time requirements
(define (problem hard-net-topology)
  (:domain AirQualityMonitoring)

  (:objects
    u1 u2 - uav
    r1 r2 r3 r4 r5 r6 r7 r8 - region
  )

  (:init
    (at u1 r1)
    (at u2 r6)

    (next r1 r2)
    (next r2 r3)
    (next r3 r4)
    (next r1 r5)
    (next r5 r4)
    (next r6 r7)
    (next r7 r8)

    (= (need-time r3) 2)
    (= (spend-time r3) 1)
    (= (need-time r4) 2)
    (= (spend-time r4) 0)
    (= (need-time r7) 3)
    (= (spend-time r7) 0)
    (= (need-time r8) 1)
    (= (spend-time r8) 0)
  )

  (:goal
    (and
        (= (spend-time r3) (need-time r3))
        (= (spend-time r4) (need-time r4))
        (= (spend-time r7) (need-time r7))
        (= (spend-time r8) (need-time r8))
    )
  )
)
