(define (problem terrain-hard-1)
  (:domain TerrainAdapt)

  (:objects
    uav1 uav2 - uav
    l1 l2 l3 l4 l5 l6 l7 - position
  )

  (:init
    (at uav1 l1)
    (at uav2 l2)
    (fly-mode uav1)
    (drive-mode uav2)

    (next l1 l2)
    (next l2 l3)
    (next l3 l4)
    (next l4 l5)
    (next l5 l6)
    (next l6 l7)

    (bad-weather l3)
    (slippery-road l5)
    (bad-weather l6)
  )

  (:goal (and
    (at uav1 l7)
    (at uav2 l6)
  ))
)
