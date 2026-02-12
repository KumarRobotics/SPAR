; test load and move
(define (problem medium-load-move)
  (:domain DeliveryDuratiion)

  (:objects
    u1 - uav
    p1 - package
    l1 l2 - location
  )

  (:init
    (at-uav u1 l1)
    (at-package p1 l1)
    (empty u1)
    (not (is-warehouse l1))
    (= (time-cost l1 l2) 4)
    (= (total-duration) 0)
  )

  (:goal
    (and
      (holding u1 p1)
      (at-uav u1 l2)
    )
  )
)
