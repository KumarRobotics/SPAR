; 2 uavs 4 packages, one uav delivers 2 packages
(define (problem hard-multi-uav-4pkgs)
  (:domain DeliveryOrderDomain-STRIPS)

  (:objects
    u1 u2 - uav
    p1 p2 p3 p4 - package
    l1 l2 l3 l4 - location
  )

  (:init
    (at-uav u1 l1)
    (at-uav u2 l2)

    (at-package p1 l1)
    (at-package p2 l2)
    (at-package p3 l1)
    (at-package p4 l2)

    (uav-empty u1)
    (uav-empty u2)

    (loadable p1)
    (loadable p2)
    (not (loadable p3))
    (not (loadable p4))

    (next p1 p3)
    (next p2 p4)
  )

  (:goal
    (and
      (delivered p1)
      (delivered p2)
      (delivered p3)
      (delivered p4)
      (at-package p1 l3)
      (at-package p2 l3)
      (at-package p3 l3)
      (at-package p4 l3)
    )
  )
)
