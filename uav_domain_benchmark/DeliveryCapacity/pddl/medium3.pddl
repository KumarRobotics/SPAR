; test load and move and unload
(define (problem medium-complete-delivery)
  (:domain DeliveryCapacityDomain)

  (:objects
    u1 - uav
    p1 - package
    l1 l2 - location
  )

  (:init
    (at-uav u1 l1)
    (at-package p1 l1)
    (= (weights p1) 3)
    (= (remaining-load) 5)
    (= (distance l1 l2) 6)
    (= (total-distance) 0)
  )

  (:goal
    (and
      (at-package p1 l2)
    )
  )
)
