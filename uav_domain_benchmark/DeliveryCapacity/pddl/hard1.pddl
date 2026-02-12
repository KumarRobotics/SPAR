; one uav, multiple deliveries 

(define (problem hard-single-uav-multidelivery)
  (:domain DeliveryCapacityDomain)

  (:objects
    u1 - uav
    p1 p2 p3 - package
    l0 l1 l2 l3 - location
  )

  (:init
    (at-uav u1 l0)

    (at-package p1 l0)
    (at-package p2 l0)
    (at-package p3 l0)

    (= (weights p1) 1)
    (= (weights p2) 1)
    (= (weights p3) 1)

    (= (remaining-load) 4)

    (= (distance l0 l1) 2)
    (= (distance l0 l2) 2)
    (= (distance l0 l3) 3)
    (= (distance l1 l0) 2)
    (= (distance l2 l0) 2)
    (= (distance l3 l0) 3)

    (= (total-distance) 0)
  )

  (:goal
    (and
      (at-package p1 l1)
      (at-package p2 l2)
      (at-package p3 l3)
    )
  )

    (:metric minimize (total-distance))
)
