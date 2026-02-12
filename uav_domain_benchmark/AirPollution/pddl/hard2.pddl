; 3 uavs, monitoring a loop
(define (problem hard-three-uav-loop)
  (:domain AirQualityMonitoring)

  (:objects
    u1 u2 u3 - uav
    a b c d e f g h - region
  )

  (:init
    (at u1 a)
    (at u2 c)
    (at u3 f)

    (next a b)
    (next b c)
    (next c d)
    (next d e)
    (next e f)
    (next f g)
    (next g a)


    (= (need-time b) 3)
    (= (spend-time b) 0)
    (= (need-time d) 2)
    (= (spend-time d) 0)
    (= (need-time f) 4)
    (= (spend-time f) 1)
    (= (need-time g) 1)
    (= (spend-time g) 0)
  )

  (:goal
    (and
      (= (spend-time b) (need-time b))
      (= (spend-time d) (need-time d))
      (= (spend-time f) (need-time f))
      (= (spend-time g) (need-time g))
    )
  )
)
