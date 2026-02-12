(define (problem recharge-then-collect)
  (:domain uav-sample-energy)
  (:objects
    u1 - uav
    s1 - sample
    l1 l2 l3 - location
  )
  (:init
    (at-uav u1 l1)
    (= (battery-power u1) 2)
    (= (recharge-capacity l2) 10)
    (= (energy-cost l1 l2) 1)
    (= (energy-cost l2 l3) 3)
    (= (energy-cost l2 l1) 1)
    (= (energy-cost l3 l2) 3)
    (at-sample s1 l3)
    (empty u1)
  )
  (:goal (and
    (at-sample s1 l1)
  ))
)
