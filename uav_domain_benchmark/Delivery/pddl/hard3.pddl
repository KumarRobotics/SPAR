; 2 uavs 4 packages
(define (problem hard-multi-uav-cross-delivery)
  (:domain DeliveryDomain)

  (:objects
    u1 u2 - uav
    p1 p2 p3 p4 - package
    l1 l2 l3 l4 l5 l6 - location
  )

  (:init
    (at-uav u1 l1)
    (at-uav u2 l2)

    (at-package p1 l1)
    (at-package p2 l3)
    (at-package p3 l4)
    (at-package p4 l5)

    (uav-empty u1)
    (uav-empty u2)
  )

  (:goal
    (and
      (at-package p1 l6)
      (at-package p2 l2)
      (at-package p3 l3)
      (at-package p4 l1)
    )
  )
)
