(define (problem terrain-medium-1)
  (:domain TerrainAdapt)

  (:objects
    uav1 - uav
    l1 l2 l3 - position
  )

  (:init
    (at uav1 l1)
    (drive-mode uav1)
    (slippery-road l1)
    (next l1 l2)
    (next l2 l3)
  )

  (:goal (and
    (at uav1 l3)
  ))
)
