; test shrink pass

(define (problem test-shrink-pass)
  (:domain GraspDelivery)

  (:objects
    u1 - uav
    l1 l2 - location
  )

  (:init
    (at u1 l1)
    (is-narrow l1)
    (shrink u1)
    (next l1 l2)
  )

  (:goal
    (at u1 l2)
  )
)
