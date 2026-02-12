; test pick next
(define (problem test-picknext-only)
  (:domain DeliveryOrderDomain-STRIPS)

  (:objects
    p1 p2 - package
  )

  (:init
    (delivered p1)
    (next p1 p2)
    (loadable p1)
  )

  (:goal
    (and
      (loadable p2)
      (not (loadable p1))
    )
  )
)
