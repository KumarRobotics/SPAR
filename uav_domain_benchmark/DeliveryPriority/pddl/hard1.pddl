; 2 uavs 3 packages
(define (problem hard-multi-uav-3pkgs)
  (:domain DeliveryOrderDomain-STRIPS)

  (:objects
    u1 u2 - uav
    p1 p2 p3 - package
    l1 l2 l3 - location
  )

  (:init
    (at-uav u1 l1)
    (at-uav u2 l2)

    (at-package p1 l1)
    (at-package p2 l2)
    (at-package p3 l1)

    (uav-empty u1)
    (uav-empty u2)

    (loadable p1)
    (not (loadable p2))
    (not (loadable p3))

    (next p1 p2)
    (next p2 p3)
  )

  (:goal
    (and
      (delivered p1)
      (delivered p2)
      (delivered p3)
      (at-package p1 l3)
      (at-package p2 l3)
      (at-package p3 l3)
    )
  )
)
