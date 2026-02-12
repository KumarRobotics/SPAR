; test move-uav + call-uav + extinguish-fire
(define (problem medium-move-call-extinguish)
  (:domain ForestFireCollabration)

  (:objects
    u1 - uav
    g1 - ugv
    a1 a2 - area
  )

  (:init
    (at-uav-location u1 a1)
    (at-ugv-location g1 a2)
    (on-fire a2)
    (next a1 a2)
    (next a2 a1)
  )

  (:goal
    (and
      (not (on-fire a2))
      (not (danger a2))
    )
  )
)
