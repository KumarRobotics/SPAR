; get one passenger, recharge midway, and transport to destination

(define (problem recharge-midway)
  (:domain uav_passenger_transport)

  (:objects
    u1 - uav
    p1 - passenger
    la lb lc ld - location
  )

  (:init
    (at-uav u1 la)
    (at-passenger p1 lb)
    (is-charging-station lc)
    (= (battery-level u1) 4)
    (= (max-battery u1) 10)
    (= (remaining-load u1) 10)
    (= (weight p1) 4)
    (= (energy-cost la lb) 1)
    (= (energy-cost lb lc) 2)
    (= (energy-cost lc ld) 4)
  )

  (:goal
    (and
      (at-passenger p1 ld)
      (= (remaining-load u1) 10)
    )
  )
)
