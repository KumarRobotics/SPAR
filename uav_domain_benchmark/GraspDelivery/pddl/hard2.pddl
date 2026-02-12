; 2 uav 2 package post gap move
(define (problem hard-two-uav-post-gap-move)
  (:domain GraspDelivery)

  (:objects
    u1 u2 - uav
    p1 p2 - package
    l1 l2 l3 l4 l5 l6 - location
  )

  (:init
    (at u1 l1)
    (at u2 l2)
    (at p1 l1)
    (at p2 l4)

    (narrow-gap l1)
    (narrow-gap l2)

    (next l1 l3)
    (next l3 l5)
    (next l2 l4)
    (next l4 l6)

    (not (shrink u1))
    (not (shrink u2))
    (not (hold u1))
    (not (hold u2))
  )

  (:goal
    (and
      (at p1 l5)
      (at p2 l6)
    )
  )
)
