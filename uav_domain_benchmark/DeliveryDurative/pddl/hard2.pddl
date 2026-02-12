(define (problem hard-routing-vs-value)
  (:domain DeliveryDuratiion)

  (:objects
    u1 u2 - uav
    p1 p2 p3 - package
    a b c d e f - location
  )

  (:init

    (at-uav u1 a)
    (at-uav u2 b)

    (at-package p1 c)
    (at-package p2 d)
    (at-package p3 e)

    (empty u1)
    (empty u2)


    (is-warehouse f)
    (not (is-warehouse a))
    (not (is-warehouse b))
    (not (is-warehouse c))
    (not (is-warehouse d))
    (not (is-warehouse e))


    (= (value p1) 5)
    (= (value p2) 15)
    (= (value p3) 10)

    (= (time-cost a b) 2)
    (= (time-cost a c) 2)
    (= (time-cost a d) 3)
    (= (time-cost a e) 2)
    (= (time-cost a f) 2)

    (= (time-cost b c) 3)
    (= (time-cost b d) 2)
    (= (time-cost b e) 3)
    (= (time-cost b f) 4)

    (= (time-cost c d) 1)
    (= (time-cost c e) 4)
    (= (time-cost c f) 3)

    (= (time-cost d e) 5)
    (= (time-cost d f) 2)

    (= (time-cost e f) 6)


    (= (total-duration) 0)
    (= (total-value) 0)
  )

  (:goal
    (and
      (> (total-value) 20)
    )
  )

  (:metric minimize (total-duration))
)
