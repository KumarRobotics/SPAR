; test unload

(define (problem test-unload)
  (:domain DeliveryDuratiion)

  (:objects
    u1 - uav
    p1 - package
    l2 - location
  )

  (:init
    (at-uav u1 l2)
    (holding u1 p1)
    (is-warehouse l2)
    (= (value p1) 10)
    (= (total-value) 0)
  )

  (:goal
    (and
      (at-package p1 l2)
    )
  )
)
