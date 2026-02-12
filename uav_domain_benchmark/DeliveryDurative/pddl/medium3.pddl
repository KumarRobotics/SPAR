; test load move unload
(define (problem medium-complete-delivery)
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
    (is-warehouse l2)
    (= (value p1) 15)
    (= (time-cost l1 l2) 5)
    (= (total-duration) 0)
    (= (total-value) 0)
  )

  (:goal
    (and
      (at-package p1 l2)
    )
  )
)
