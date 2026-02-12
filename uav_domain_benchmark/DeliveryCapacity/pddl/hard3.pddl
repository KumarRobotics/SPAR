(define (problem hard-scattered-packages-to-hub)
  (:domain DeliveryCapacityDomain)

  (:objects
    u1 - uav
    p1 p2 p3 - package
    l0 l1 l2 l3 - location
  )

  (:init
    (at-uav u1 l0)

    (at-package p1 l1)
    (at-package p2 l2)
    (at-package p3 l3)

    (= (weights p1) 2)
    (= (weights p2) 2)
    (= (weights p3) 2)

    (= (remaining-load) 4)

    ;; distances to/from l0
    (= (distance l0 l1) 2)
    (= (distance l1 l0) 2)
    (= (distance l0 l2) 2)
    (= (distance l2 l0) 2)
    (= (distance l0 l3) 2)
    (= (distance l3 l0) 2)

    (= (total-distance) 0)
  )

  (:goal
    (and
      (at-package p1 l0)
      (at-package p2 l0)
      (at-package p3 l0)
    )
  )

    (:metric minimize (total-distance))
)
