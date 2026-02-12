; test move-uav + call-uav + extinguish-fire + move-uav
(define (problem medium-uav-round-trip)
  (:domain ForestFireCollabration)

  (:objects
    u1 - uav
    g1 - ugv
    a1 a2 a3 - area
  )

  (:init
    (at-uav-location u1 a1)
    (at-ugv-location g1 a3)
    (on-fire a2)
    (next a1 a2)
    (next a2 a3)
    (next a3 a1)
  )

  (:goal
    (and
      (not (on-fire a2))
      (not (danger a2))
      (at-uav-location u1 a1)
    )
  )
)
