; 3 fire, 2 uav, 2 ugv
(define (problem hard-3fire-2uav-2ugv)
  (:domain ForestFireCollabration)

  (:objects
    u1 u2 - uav
    g1 g2 - ugv
    a1 a2 a3 a4 - area
  )

  (:init
    (at-uav-location u1 a1)
    (at-uav-location u2 a2)
    (at-ugv-location g1 a1)
    (at-ugv-location g2 a2)

    (on-fire a2)
    (on-fire a3)
    (on-fire a4)

    (next a1 a2)
    (next a2 a3)
    (next a3 a4)
    (next a4 a1)
    (next a2 a1)
    (next a3 a2)
    (next a4 a3)
    (next a1 a4)
  )

  (:goal
    (and
      (not (on-fire a2))
      (not (on-fire a3))
      (not (on-fire a4))
      (not (danger a2))
      (not (danger a3))
      (not (danger a4))
    )
  )
)
