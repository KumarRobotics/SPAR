; test move action
(define (problem test-move)
  (:domain uav_passenger_transport)

  (:objects
    u1 - uav
    locA locB locC - location
  )

  (:init
    (at-uav u1 locA)
    (= (battery-level u1) 8)
    (= (energy-cost locA locB) 5)
    (= (energy-cost locB locC) 2)
  )

  (:goal
    (at-uav u1 locC)
  )
)
