; get 2 passengers to destination

(define (problem transport-two-passengers)
  (:domain uav_passenger_transport)

  (:objects
    u1 - uav
    p1 p2 - passenger
    l1 l2 l3 l4 - location
  )

  (:init
    (at-uav u1 l1)
    (at-passenger p1 l2)
    (at-passenger p2 l3)
    (= (battery-level u1) 200)
    (= (max-battery u1) 20)
    (= (remaining-load u1) 5)
    (= (weight p1) 2)
    (= (weight p2) 3)
    (= (energy-cost l1 l2) 2)
    (= (energy-cost l2 l3) 2)
    (= (energy-cost l3 l4) 3)
  )

  (:goal
    (and (at-passenger p1 l4)
         (at-passenger p2 l4)
          (= (remaining-load u1) 5)
         )
  )
)
