; test unload

(define (problem test-unload)
  (:domain DeliveryCapacityDomain)

  (:objects
    u1 - uav
    p1 - package
    l1 - location
  )

  (:init
    (at-uav u1 l1)
    (holding u1 p1)
    (= (weights p1) 3)
    (= (remaining-load) 2)
  )

  (:goal
    (and
      (at-package p1 l1)
    )
  )
)
