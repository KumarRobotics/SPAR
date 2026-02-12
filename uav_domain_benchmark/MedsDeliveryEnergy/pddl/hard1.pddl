(define (problem dual-uav-two-sample-delivery)
  (:domain uav-sample-energy)
  (:objects
    u1 u2 - uav
    s1 s2 - sample
    l1 l2 l3 l4 - location
  )
  (:init
    (at-uav u1 l1)
    (at-uav u2 l2)
    (at-sample s1 l3)
    (at-sample s2 l4)
    (empty u1)
    (empty u2)
    (= (battery-power u1) 5)
    (= (battery-power u2) 5)
    (= (energy-cost l1 l3) 2)
    (= (energy-cost l3 l2) 2)
    (= (energy-cost l2 l4) 2)
    (= (energy-cost l4 l1) 2)
  )
  (:goal (and
    (at-sample s1 l2)
    (at-sample s2 l1)
  ))
)
