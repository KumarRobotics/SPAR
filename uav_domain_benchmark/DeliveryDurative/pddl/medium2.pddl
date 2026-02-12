; test move and unload
(define (problem medium-move-unload)
  (:domain DeliveryDuratiion)

  (:objects
    u1 - uav
    p1 - package
    l1 l2 - location
  )

  (:init
    (at-uav u1 l1)
    (holding u1 p1)
    (is-warehouse l2)
    (= (time-cost l1 l2) 3)
    (= (value p1) 10)
    (= (total-duration) 0)
    (= (total-value) 0)
  )

  (:goal
    (and
      (at-package p1 l2)
    )
  )
)
