; test picknext and deliver
(define (problem medium-picknext-continue)
  (:domain DeliveryOrderDomain-STRIPS)

  (:objects
    u1 - uav
    p1 p2 - package
    l1 l2 - location
  )

  (:init
    (at-uav u1 l1)
    (at-package p2 l1)
    (uav-empty u1)

    (delivered p1)
    (next p1 p2)

    (not (loadable p2))
  )

  (:goal
    (and
      (at-package p2 l2)
    )
  )
)
