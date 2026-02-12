(define (problem full-sample-delivery)
  (:domain uav-sample-energy)
  (:objects
    u1 - uav
    s1 - sample
    l1 l2 l3 - location
  )
  (:init
    (at-uav u1 l1)
    (at-sample s1 l2)
    (empty u1)
    (= (battery-power u1) 6)
    (= (energy-cost l1 l2) 2)
    (= (energy-cost l2 l3) 2)
  )
  (:goal (and
    (at-sample s1 l3)
  ))
)
