(define (problem terrain-hard-2)
  (:domain TerrainAdapt)

  (:objects
    u1 u2 u3 - uav
    a1 a2 a3 a4
    b1 b2 b3 b4
    c1 c2 c3 c4 - position
  )

  (:init
    (at u1 a1)
    (at u2 b1)
    (at u3 c1)

    (fly-mode u1)
    (drive-mode u2)
    (fly-mode u3)

    ;; UAV1 path: fly - switch - drive
    (next a1 a2)
    (next a2 a3)
    (next a3 a4)
    (bad-weather a3)

    ;; UAV2 path: drive - switch - fly
    (next b1 b2)
    (next b2 b3)
    (next b3 b4)
    (slippery-road b2)

    ;; UAV3 path: fly + weather challenges
    (next c1 c2)
    (next c2 c3)
    (next c3 c4)
    (bad-weather c2)
    (slippery-road c3)
  )

  (:goal (and
    (at u1 a4)
    (at u2 b4)
    (at u3 c4)
  ))
)
