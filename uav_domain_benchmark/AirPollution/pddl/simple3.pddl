; test action move on topo map

(define (problem move-and-monitor-graph)
  (:domain AirQualityMonitoring)

  (:objects
    u1 - uav
    r1 r2 r3 r4 r5 r6 - region
  )

  (:init
    (at u1 r1)

    (next r1 r2)
    (next r1 r3)
    (next r2 r4)
    (next r3 r4)
    (next r4 r5)
    (next r5 r6)

  )

  (:goal
    (at u1 r6)
  )
)
