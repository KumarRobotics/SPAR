(define (problem hard-dual-uav-max-value)
  (:domain DeliveryDuratiion)

  (:objects
    u1 u2 - uav
    p1 p2 - package
    l1 l2 l3 l4 - location
  )

  (:init

    (at-uav u1 l1)
    (at-uav u2 l2)

    (at-package p1 l1)
    (at-package p2 l2)

    (empty u1)
    (empty u2)

    (= (value p1) 10)
    (= (value p2) 15)


    (is-warehouse l3)
    (is-warehouse l4)
    (not (is-warehouse l1))
    (not (is-warehouse l2))

    (= (time-cost l1 l3) 5)
    (= (time-cost l2 l4) 3)
    (= (total-duration) 0)
    (= (total-value) 0)
  )

  (:goal
    (and
      (at-package p1 l3)
      (at-package p2 l4)
    )
  )

  (:metric maximize (total-value))
)
