; test load

(define (problem test-load)
  (:domain DeliveryCapacityDomain)

  (:objects
    u1 - uav
    p1 - package
    l1 - location
  )

  (:init
    (at-uav u1 l1)
    (at-package p1 l1)
    (= (weights p1) 2)
    (= (remaining-load) 5)
  )

  (:goal
    (holding u1 p1)
  )
)
