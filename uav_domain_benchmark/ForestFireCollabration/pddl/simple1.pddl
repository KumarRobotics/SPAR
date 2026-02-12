; test call-uav
(define (problem test-call-uav)
  (:domain ForestFireCollabration)

  (:objects
    u1 - uav
    a1 - area
  )

  (:init
    (at-uav-location u1 a1)
    (on-fire a1)
  )

  (:goal
    (danger a1)
  )
)
