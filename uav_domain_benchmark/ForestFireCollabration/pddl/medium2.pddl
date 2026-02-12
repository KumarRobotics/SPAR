; test move-uav + call-uav + extinguish-fire + 2 locations
(define (problem medium-double-fire)
  (:domain ForestFireCollabration)

  (:objects
    u1 - uav
    g1 - ugv
    a1 a2 a3 - area
  )

  (:init
    (at-uav-location u1 a1)
    (at-ugv-location g1 a1)
    (on-fire a2)
    (on-fire a3)
    (next a1 a2)
    (next a2 a3)
    (next a3 a1)
  )

  (:goal
    (and
      (not (on-fire a2))
      (not (on-fire a3))
      (not (danger a2))
      (not (danger a3))
    )
  )
)
