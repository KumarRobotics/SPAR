; single uav, multiple passengers, can't load them all at once, must transport one by one

(define (problem hard-distributed-passengers-recharge)
  (:domain uav_passenger_transport)

  (:objects
    u1 - uav
    p1 p2 - passenger
    la lb lc ld le lf - location
  )

  (:init
    (at-uav u1 la)
    (at-passenger p1 lb)
    (at-passenger p2 lb)
    (is-charging-station lc)
    (= (battery-level u1) 6)
    (= (max-battery u1) 6)
    (= (remaining-load u1) 4)
    (= (weight p1) 2)
    (= (weight p2) 3)
    
    (= (energy-cost la lb) 2)
    (= (energy-cost la lc) 3)
    (= (energy-cost la ld) 2)
    (= (energy-cost la le) 2)
    (= (energy-cost la lf) 1)

    (= (energy-cost lb ld) 3)
    (= (energy-cost lb la) 2)
    (= (energy-cost lb lc) 2)
    (= (energy-cost lb le) 2)
    (= (energy-cost lb lf) 2)

    (= (energy-cost lc ld) 3)
    (= (energy-cost lc la) 2)
    (= (energy-cost lc lb) 2)
    (= (energy-cost lc le) 2)
    (= (energy-cost lc lf) 1)

    (= (energy-cost ld la) 3)
    (= (energy-cost ld lb) 2)
    (= (energy-cost ld lc) 2)
    (= (energy-cost ld le) 2)
    (= (energy-cost ld lf) 2)

    (= (energy-cost le la) 3)
    (= (energy-cost le lb) 2)
    (= (energy-cost le lc) 2)
    (= (energy-cost le ld) 2)
    (= (energy-cost le lf) 1)

    (= (energy-cost lf la) 3)
    (= (energy-cost lf lb) 2)
    (= (energy-cost lf lc) 2)
    (= (energy-cost lf ld) 2)
    (= (energy-cost lf le) 1)

  )

  (:goal
    (and
      (at-passenger p1 lf)
      (at-passenger p2 lf)
      (= (remaining-load u1) 4)
    )
  )
)
