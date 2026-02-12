(define (problem terrain-hard-3)
  (:domain TerrainAdapt)

  (:objects
    d1 d2 - uav
    p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 - position
  )

  (:init
    (at d1 p1)
    (at d2 p6)

    (fly-mode d1)
    (fly-mode d2)

    ;; common path
    (next p1 p2) (next p2 p3) (next p3 p4) (next p4 p5)
    (next p6 p7) (next p7 p8) (next p8 p9) (next p9 p10)

    (bad-weather p3)
    (slippery-road p4)
    (bad-weather p8)
    (slippery-road p9)
  )

  (:goal (and
    (at d1 p5)
    (at d2 p10)
  ))
)
