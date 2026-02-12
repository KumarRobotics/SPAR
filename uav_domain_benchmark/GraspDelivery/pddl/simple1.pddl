; test detect-obs
(define (problem test-detect-obstacle)
  (:domain GraspDelivery)

  (:objects
    u1 - uav
    l1 - location
  )

  (:init
    (at u1 l1)
    (narrow-gap l1)
  )

  (:goal
    (and
      (is-narrow l1)
      (not (clear l1))
    )
  )
)
