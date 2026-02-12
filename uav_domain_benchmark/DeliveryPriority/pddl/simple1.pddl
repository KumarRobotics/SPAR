; test load
(define (problem test-load)
  (:domain DeliveryOrderDomain-STRIPS)

  (:objects
    u1 - uav
    p1 - package
    l1 - location
  )

  (:init
    (at-uav u1 l1)
    (at-package p1 l1)
    (uav-empty u1)
    (loadable p1)
  )

  (:goal
    (holding u1 p1)
  )
)
