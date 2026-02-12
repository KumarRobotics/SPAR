; test call-uav + extinguish-fire
(define (problem test-call-then-extinguish)
  (:domain ForestFireCollabration)

  (:objects
    u1 - uav
    g1 - ugv
    a1 - area
  )

  (:init
    (at-uav-location u1 a1)
    (at-ugv-location g1 a1)
    (on-fire a1)
  )

  (:goal
    (and
      (not (on-fire a1))
      (not (danger a1))
    )
  )
)
