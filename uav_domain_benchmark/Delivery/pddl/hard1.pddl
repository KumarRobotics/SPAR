; 2 uavs 2 packages
(define (problem hard-two-uav-two-packages)
  (:domain DeliveryDomain)

  (:objects
    u1 u2 - uav
    p1 p2 - package
    l1 l2 l3 l4 - location
  )

  (:init
    (at-uav u1 l1)
    (at-uav u2 l2)
    (at-package p1 l1)
    (at-package p2 l2)
    (uav-empty u1)
    (uav-empty u2)
  )

  (:goal
    (and
      (at-package p1 l3)
      (at-package p2 l4)
    )
  )
)
