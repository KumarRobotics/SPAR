; test action load
(define (problem test-load)
  (:domain DeliveryDomain)

  (:objects
    u1 - uav
    p1 - package
    l1 - location
  )

  (:init
    (at-uav u1 l1)
    (at-package p1 l1)
    (uav-empty u1)
  )

  (:goal
    (holding u1 p1)
  )
)
