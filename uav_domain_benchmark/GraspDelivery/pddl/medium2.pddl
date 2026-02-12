; test detect clear grasp move unload
(define (problem medium-grasp-detect-move-unload)
  (:domain GraspDelivery)

  (:objects
    u1 - uav
    l1 l2 - location
    p1 - package
  )

  (:init
    (at u1 l1)
    (at p1 l1)
    (not (hold u1))
    (not (shrink u1))
    (next l1 l2)
  )

  (:goal
    (and
      (at p1 l2)
    )
  )
)
