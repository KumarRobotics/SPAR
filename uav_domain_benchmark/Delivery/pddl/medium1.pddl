; test load and move

(define (problem medium-load-move)
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
      (holding u1 p1)
      (at-uav u1 l2)
    )
  )
)
