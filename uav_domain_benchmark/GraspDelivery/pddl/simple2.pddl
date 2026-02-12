; test grasp
(define (problem test-grasp)
  (:domain GraspDelivery)

  (:objects
    u1 - uav
    l1 - location
    p1 - package
  )

  (:init
    (at u1 l1)
    (at p1 l1)
  )

  (:goal
    (and
      (hold u1)
      (shrink u1)
    )
  )
)
