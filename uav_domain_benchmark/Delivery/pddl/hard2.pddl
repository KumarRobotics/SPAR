; two uavs, three packages

(define (problem hard-three-packages-multi-leg)
  (:domain DeliveryDomain)

  (:objects
    u1 u2 - uav
    p1 p2 p3 - package
    l1 l2 l3 l4 l5 - location
  )

  (:init
    (at-uav u1 l1)
    (at-uav u2 l2)

    (at-package p1 l1)
    (at-package p2 l3)
    (at-package p3 l4)

    (uav-empty u1)
    (uav-empty u2)
  )

  (:goal
    (and
      (at-package p1 l5)
      (at-package p2 l1)
      (at-package p3 l2)
    )
  )
)
