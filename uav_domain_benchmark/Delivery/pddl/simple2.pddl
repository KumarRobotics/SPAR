; test action unload

(define (problem test-unload)
  (:domain DeliveryDomain)

  (:objects
    u1 - uav
    p1 - package
    l1 - location
  )

  (:init
    (at-uav u1 l1)
    (holding u1 p1)
  )

  (:goal
    (and
      (at-package p1 l1)
    )
  )
)
