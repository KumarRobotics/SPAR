(define (problem test-travel)
  (:domain uav-sample-energy)
  (:objects
    u1 - uav
    l1 l2 - location
  )
  (:init
    (at-uav u1 l1)
    (= (battery-power u1) 5)
    (= (energy-cost l1 l2) 3)
  )
  (:goal (and
    (at-uav u1 l2)
  ))
)
