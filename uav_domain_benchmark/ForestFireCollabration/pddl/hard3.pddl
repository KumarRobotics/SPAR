; all fire, 3 uav, 3 ugv 6 area
(define (problem hard-fullfire-multibot)
  (:domain ForestFireCollabration)

  (:objects
    u1 u2 u3 - uav
    g1 g2 g3 - ugv
    a1 a2 a3 a4 a5 a6 - area
  )

  (:init
    (at-uav-location u1 a1)
    (at-uav-location u2 a3)
    (at-uav-location u3 a5)

    (at-ugv-location g1 a2)
    (at-ugv-location g2 a4)
    (at-ugv-location g3 a6)

    (on-fire a1)
    (on-fire a2)
    (on-fire a3)
    (on-fire a4)
    (on-fire a5)
    (on-fire a6)

    (next a1 a2) (next a2 a3) (next a3 a4)
    (next a4 a5) (next a5 a6) (next a6 a1)

    (next a2 a1) (next a3 a2) (next a4 a3)
    (next a5 a4) (next a6 a5) (next a1 a6)
  )

  (:goal
    (and
      (not (on-fire a1)) (not (danger a1))
      (not (on-fire a2)) (not (danger a2))
      (not (on-fire a3)) (not (danger a3))
      (not (on-fire a4)) (not (danger a4))
      (not (on-fire a5)) (not (danger a5))
      (not (on-fire a6)) (not (danger a6))
    )
  )
)
