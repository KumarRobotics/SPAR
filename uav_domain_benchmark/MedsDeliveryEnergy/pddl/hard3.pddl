(define (problem full-mission-multi-sample)
  (:domain uav-sample-energy)
  (:objects
    u2 - uav
    s1 s2 s3 - sample
    l1 l2 l3 l4 l5 l6 - location
  )
  (:init
    (at-uav u2 l2)
    (at-sample s1 l3)
    (at-sample s2 l4)
    (at-sample s3 l5)
    (empty u2)
    (= (battery-power u2) 2)
    (= (recharge-capacity l6) 6)

    (= (energy-cost l1 l6) 1)
    (= (energy-cost l2 l6) 1)
    (= (energy-cost l6 l3) 2)
    (= (energy-cost l6 l4) 2)
    (= (energy-cost l6 l5) 3)
    (= (energy-cost l3 l1) 2)
    (= (energy-cost l4 l2) 2)
    (= (energy-cost l5 l1) 2)
  )
  (:goal (and
    (at-sample s1 l1)
    (at-sample s2 l2)
    (at-sample s3 l1)
  ))
)
