; test detect gap-shrink-pass
(define (problem medium-detect-shrink-pass-unload)
  (:domain GraspDelivery)

  (:objects
    u1 - uav
    l1 l2 - location
  )

  (:init
    (at u1 l1)
    (narrow-gap l1)
    (next l1 l2)
  )

  (:goal
    (and
      (at u1 l2)
    )
  )
)
