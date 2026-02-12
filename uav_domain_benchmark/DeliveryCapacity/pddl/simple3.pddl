; test move
(define (problem test-move)
  (:domain DeliveryCapacityDomain)

  (:objects
    u1 - uav
    l1 l2 - location
  )

  (:init
    (at-uav u1 l1)
    (= (distance l1 l2) 5)
    (= (total-distance) 0)
  )

  (:goal
    (and
      (at-uav u1 l2)
    )
  )
)
