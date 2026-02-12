; test detect shrink move grasp pass unload
(define (problem medium-shrink-move-grasp-pass-unload)
  (:domain GraspDelivery)

  (:objects
    u1 - uav
    l1 l2 l3 - location
    p1 - package
  )

  (:init
    (at u1 l1)
    (at p1 l2)
    (narrow-gap l2)
    (next l1 l2)
    (next l2 l3)
  )

  (:goal
    (and
      (at p1 l3)
    )
  )
)
