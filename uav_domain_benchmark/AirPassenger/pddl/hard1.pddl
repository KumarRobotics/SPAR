; one uav, multiple passengers, can't load them all at once, must transport one by one

(define (problem hard-multi-passengers-single-uav)
  (:domain uav_passenger_transport)

  (:objects
    u1 - uav
    p1 p2 - passenger
    a b c d - location
  )

  (:init
    (at-uav u1 a)
    (at-passenger p1 b)
    (at-passenger p2 c)
    (= (battery-level u1) 1000)
    (= (max-battery u1) 100)
    (= (remaining-load u1) 4)
    (= (weight p1) 3)
    (= (weight p2) 3)
    
    (= (energy-cost a b) 2)
    (= (energy-cost a c) 3)
    (= (energy-cost a d) 2)
    (= (energy-cost b d) 3)
    (= (energy-cost b a) 2)
    (= (energy-cost b c) 2)
    (= (energy-cost c d) 3)
    (= (energy-cost c a) 2)
    (= (energy-cost c b) 2)
    (= (energy-cost d a) 3)
    (= (energy-cost d b) 2)
    (= (energy-cost d c) 3)

  )

  (:goal
    (and
      (at-passenger p1 d)
      (at-passenger p2 d)
      (= (remaining-load u1) 4)
    )
  )
)
