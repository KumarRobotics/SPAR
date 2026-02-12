; 2 uavs paints 3 positions
(define (problem hard-uav-swap-sprayers)
  (:domain CeilingPaintDomain)

  (:objects
    u1 u2 - uav
    red blue - color
    sr1 sr2 sb1 sb2 - sprayer
    p0 p1 p2 p3 - position
  )

  (:init
    (landed u1)
    (landed u2)
    (empty u1)
    (empty u2)
    (uav-at u1 p0)
    (uav-at u2 p0)
    (sprayer-color sr1 red)
    (sprayer-color sr2 red)
    (sprayer-color sb1 blue)
    (sprayer-color sb2 blue)
    (clear p1)
    (clear p2)
    (clear p3)
  )

  (:goal
    (and
      (painted p1 red)
      (painted p2 blue)
      (painted p3 red)
    )
  )
)
