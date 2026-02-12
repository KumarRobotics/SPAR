(define (problem test-recharge)
  (:domain uav-sample-energy)
  (:objects
    u1 - uav
    l1 - location
  )
  (:init
    (at-uav u1 l1)
    (= (battery-power u1) 2)
    (= (recharge-capacity l1) 10)
  )
  (:goal (and
    (= (battery-power u1) 10)
  ))
)
