; test load and move

(define (problem medium-load-move)
  (:domain DeliveryCapacityDomain)

  (:objects
    u1 - uav
    p1 - package
    l1 l2 - location
  )

  (:init
    (at-uav u1 l1)
    (at-package p1 l1)
    (= (weights p1) 4)
    (= (remaining-load) 5)
    (= (distance l1 l2) 3)
    (= (total-distance) 0)
  )

  (:goal
    (and
      (holding u1 p1)
      (at-uav u1 l2)
    )
  )
)
