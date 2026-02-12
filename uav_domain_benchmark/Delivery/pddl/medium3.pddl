; test load-move-unload with 2 deliveries

(define (problem medium-two-deliveries)
  (:domain DeliveryDomain)

  (:objects
    u1 - uav
    p1 p2 - package
    l1 l2 - location
  )

  (:init
    (at-uav u1 l1)
    (at-package p1 l1)
    (at-package p2 l2)
    (uav-empty u1)
  )

  (:goal
    (and
      (at-package p1 l2)
      (at-package p2 l1)
    )
  )
)
