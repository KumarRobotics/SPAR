(define (problem shared-recharge-multi-delivery)
  (:domain uav-sample-energy)
  (:objects
    u2 - uav
    s1 s2 - sample
    l1 l2 l3 l4 lR - location
  )
  (:init
    (at-uav u2 l2)
    (at-sample s1 l3)
    (at-sample s2 l4)
    (= (recharge-capacity lR) 7)
    (= (battery-power u2) 2)
    (empty u2)
    (= (energy-cost l1 lR) 1)
    (= (energy-cost lR l3) 2)
    (= (energy-cost l3 l2) 2)
    (= (energy-cost l2 lR) 1)
    (= (energy-cost lR l4) 2)
    (= (energy-cost l4 l1) 2)
  )
  (:goal (and
    (at-sample s1 l2)
    (at-sample s2 l1)
  ))
)
