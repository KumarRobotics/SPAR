(define (problem travel-then-collect)
  (:domain uav-sample-energy)
  (:objects
    u1 - uav
    s1 - sample
    l1 l2 - location
  )
  (:init
    (at-uav u1 l1)
    (at-sample s1 l2)
    (empty u1)
    (= (battery-power u1) 5)
    (= (energy-cost l1 l2) 3)
  )
  (:goal (and
    (holding u1 s1)
  ))
)
