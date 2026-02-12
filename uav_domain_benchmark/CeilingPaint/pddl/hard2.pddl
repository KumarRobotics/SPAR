; 3 uavs paints 3 positions with different colors
(define (problem hard-triple-uav-multicolor)
  (:domain CeilingPaintDomain)

  (:objects
    u1 u2 u3 - uav
    red blue green - color
    sr sb sg - sprayer
    p0 p1 p2 p3 - position
  )

  (:init
    (landed u1)
    (landed u2)
    (landed u3)
    (empty u1)
    (empty u2)
    (empty u3)
    (uav-at u1 p0)
    (uav-at u2 p0)
    (uav-at u3 p0)
    (sprayer-color sr red)
    (sprayer-color sb blue)
    (sprayer-color sg green)
    (clear p1)
    (clear p2)
    (clear p3)
  )

  (:goal
    (and
      (painted p1 red)
      (painted p2 blue)
      (painted p3 green)
    )
  )
)
