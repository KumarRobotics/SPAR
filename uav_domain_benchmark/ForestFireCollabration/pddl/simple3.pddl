; test move-uav + call-uav
(define (problem test-move-call)
  (:domain ForestFireCollabration)

  (:objects
    u1 - uav
    a1 a2 - area
  )

  (:init
    (at-uav-location u1 a1)
    (on-fire a2)
    (next a1 a2)
  )

  (:goal
    (danger a2)
  )
)
