; test load
(define (problem test-load)
  (:domain DeliveryDuratiion)

  (:objects
    u1 - uav
    p1 - package
    l1 - location
  )

  (:init
    (at-uav u1 l1)
    (at-package p1 l1)
    (empty u1)
    (not (is-warehouse l1))
  )

  (:goal
    (holding u1 p1)
  )
)
