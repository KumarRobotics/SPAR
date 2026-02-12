; get 1 passenger to destination

(define (problem transport-one-passenger)
  (:domain uav_passenger_transport)

  (:objects
    u1 - uav
    p1 - passenger
    locA locB locC - location
  )

  (:init
    (at-uav u1 locA)
    (at-passenger p1 locB)
    (= (battery-level u1) 10)
    (= (max-battery u1) 10)
    (= (remaining-load u1) 5)
    (= (weight p1) 3)
    (= (energy-cost locA locB) 2)
    (= (energy-cost locB locC) 3)
  )

  (:goal
    (and
      (at-passenger p1 locC)
      (= (remaining-load u1) 5)
    )
  )
)
