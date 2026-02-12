; test monitor action

(define (problem simple-monitoring)
  (:domain AirQualityMonitoring)

  (:objects
    u1 - uav
    r1 - region
  )

  (:init
    (at u1 r1)
    (= (need-time r1) 2)
    (= (spend-time r1) 0)
  )

  (:goal
    (= (spend-time r1) (need-time r1))
  )
)
