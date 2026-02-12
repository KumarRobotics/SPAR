(define (problem terrain-medium-2)
  (:domain TerrainAdapt)

  (:objects
    uav1 - uav
    l1 l2 l3 - position
  )

  (:init
    (at uav1 l1)
    (fly-mode uav1)
    (bad-weather l2)
    (next l1 l2)
    (next l2 l3)
  )

  (:goal (and
    (at uav1 l3)
  ))
)
