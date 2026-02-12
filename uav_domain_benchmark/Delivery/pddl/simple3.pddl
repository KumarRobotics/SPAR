; test action move
(define (problem test-move)
  (:domain DeliveryDomain)

  (:objects
    u1 - uav
    l1 l2 - location
  )

  (:init
    (at-uav u1 l1)
  )

  (:goal
    (at-uav u1 l2)
  )
)
