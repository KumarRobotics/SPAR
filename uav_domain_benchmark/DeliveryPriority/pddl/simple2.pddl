; test load move unload
(define (problem test-load-move-unload)
  (:domain DeliveryOrderDomain-STRIPS)

  (:objects
    u1 - uav
    p1 - package
    l1 l2 - location
  )

  (:init
    (at-uav u1 l1)
    (at-package p1 l1)
    (uav-empty u1)
    (loadable p1)
  )

  (:goal
    (and
      (delivered p1)
      (at-package p1 l2)
    )
  )
)
