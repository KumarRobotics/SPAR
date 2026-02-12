(define (problem terrain-medium-3)
  (:domain TerrainAdapt)

  (:objects
    uav1 - uav
    l1 l2 l3 l4 l5 - position
  )

  (:init
    (at uav1 l1)
    (fly-mode uav1)
    (bad-weather l2)
    (slippery-road l3)
    (bad-weather l4)
    (next l1 l2)
    (next l2 l3)
    (next l3 l4)
    (next l4 l5)
  )

  (:goal (and
    (at uav1 l5)
  ))
)
