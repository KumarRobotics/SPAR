; test move

(define (problem test-move)
  (:domain DeliveryDuratiion)

  (:objects
    u1 - uav
    l1 l2 - location
  )

  (:init
    (at-uav u1 l1)
    (= (time-cost l1 l2) 3)
    (= (total-duration) 0)
  )

  (:goal
    (at-uav u1 l2)
  )
)
