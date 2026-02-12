; multiple region,partial data monitoring,branching road

(define (problem medium-branching-with-partial-data)
  (:domain AirQualityMonitoring)

  (:objects
    u1 - uav
    r1 r2 r3 r4 r5 - region
  )

  (:init
    (at u1 r1)
    (next r1 r2)
    (next r1 r3)
    (next r2 r4)
    (next r4 r1)
    (next r3 r5)

    (= (need-time r4) 5)
    (= (spend-time r4) 1)
    (= (need-time r5) 2)
    (= (spend-time r5) 0)
  )

  (:goal
    (and
      (= (spend-time r4) (need-time r4))
      (= (spend-time r5) (need-time r5))
    )
  )
)
