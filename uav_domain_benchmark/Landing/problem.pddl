(define (problem UAV-Landing-Problem)
  (:domain UAV-Landing)

  (:objects
    drone1 - uav
    loc1 loc2 loc3 - location
  )

  (:init

    (at drone1 loc1)
    (in-air drone1)

    (connected loc1 loc2)
    (connected loc2 loc3)

    ;(clear loc2)
    (clear loc3)
  )

  (:goal
    (and
      (landed drone1)
    )
  )
)
