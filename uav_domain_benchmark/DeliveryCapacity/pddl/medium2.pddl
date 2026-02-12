; test move and unload
(define (problem medium-move-unload)
  (:domain DeliveryCapacityDomain)

  (:objects
    u1 - uav
    p1 - package
    l1 l2 - location
  )

  (:init
    (at-uav u1 l1)
    (holding u1 p1)
    (= (weights p1) 2)
    (= (remaining-load) 3)
    (= (distance l1 l2) 4)
    (= (total-distance) 0)
  )

  (:goal
    (and
      (at-package p1 l2)
    )
  )
)
