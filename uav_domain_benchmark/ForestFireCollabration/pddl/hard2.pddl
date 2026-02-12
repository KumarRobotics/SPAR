; four fire 3 uav 2 ugv
(define (problem hard-4fire-grid)
  (:domain ForestFireCollabration)

  (:objects
    u1 u2 u3 - uav
    g1 g2 - ugv
    a1 a2 a3 a4 a5 - area
  )

  (:init
    (at-uav-location u1 a1)
    (at-uav-location u2 a2)
    (at-uav-location u3 a3)

    (at-ugv-location g1 a4)
    (at-ugv-location g2 a5)

    (on-fire a1)
    (on-fire a2)
    (on-fire a4)
    (on-fire a5)

    (next a1 a2)
    (next a2 a3)
    (next a3 a4)
    (next a4 a5)
    (next a5 a1)
    (next a1 a3)
    (next a2 a4)
  )

  (:goal
    (and
      (not (on-fire a1))
      (not (on-fire a2))
      (not (on-fire a4))
      (not (on-fire a5))
      (not (danger a1))
      (not (danger a2))
      (not (danger a4))
      (not (danger a5))
    )
  )
)
