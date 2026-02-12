; one uav, multiple regions, looped graph

(define (problem medium-looped-graph)
  (:domain AirQualityMonitoring)

  (:objects
    u1 - uav
    a b c d e - region
  )

  (:init
    (at u1 a)
    (next a b)
    (next b c)
    (next c d)
    (next d e)
    (next e a) ;; forms a loop

    (= (need-time b) 3)
    (= (spend-time b) 0)
    (= (need-time d) 1)
    (= (spend-time d) 0)
    (= (need-time c) 6)
    (= (spend-time c) 0)
  )

  (:goal
    (and
      (= (spend-time b) (need-time b))
      (= (spend-time d) (need-time d))
      (= (spend-time c) (need-time c))
    )
  )
)
