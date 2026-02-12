; two uavs, 3 passengers need charging
(define (problem hard-two-uav-three-passengers)
  (:domain uav_passenger_transport)

  (:objects
    u1 u2 - uav
    p1 p2 p3 - passenger
    l1 l2 l3 l4 l5 - location
  )

  (:init
    (at-uav u1 l1)
    (at-uav u2 l2)
    (at-passenger p1 l3)
    (at-passenger p2 l1)
    (at-passenger p3 l3)
    (is-charging-station l2)

    (= (battery-level u1) 6)
    (= (battery-level u2) 3)
    (= (max-battery u1) 6)
    (= (max-battery u2) 6)

    (= (remaining-load u1) 2)
    (= (remaining-load u2) 4)
    (= (weight p1) 3)
    (= (weight p2) 3)
    (= (weight p3) 2)

    (= (energy-cost l1 l3) 2)
    (= (energy-cost l1 l2) 2)
    (= (energy-cost l1 l4) 3)
    (= (energy-cost l1 l5) 2)

    (= (energy-cost l2 l3) 3)
    (= (energy-cost l2 l1) 2)
    (= (energy-cost l2 l4) 2)
    (= (energy-cost l2 l5) 1)

    (= (energy-cost l3 l4) 2)
    (= (energy-cost l3 l1) 3)
    (= (energy-cost l3 l2) 2)
    (= (energy-cost l3 l5) 3)

    (= (energy-cost l4 l1) 2)
    (= (energy-cost l4 l2) 2)
    (= (energy-cost l4 l3) 2)
    (= (energy-cost l4 l5) 2)

    (= (energy-cost l5 l1) 3)
    (= (energy-cost l5 l2) 1)
    (= (energy-cost l5 l3) 2)
    (= (energy-cost l5 l4) 2)

  )

  (:goal
    (and
      (at-passenger p1 l5)
      (at-passenger p2 l5)
      (at-passenger p3 l5)
      (= (remaining-load u1) 2)
      (= (remaining-load u2) 4)
    )
  )
)
