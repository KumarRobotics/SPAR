; test load and move and unload

(define (problem medium-complete-delivery)
  (:domain DeliveryDomain)

  (:objects
    u1 - uav
    p1 - package
    l1 l2 - location
  )

  (:init
    (at-uav u1 l1)
    (at-package p1 l1)
    (uav-empty u1)
  )

  (:goal
    (and
      (at-package p1 l2)
    )
  )
)
