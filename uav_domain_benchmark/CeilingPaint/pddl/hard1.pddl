; two uav paints two positions with different colors

(define (problem hard-two-uav-split-color-task)
  (:domain CeilingPaintDomain)

  (:objects
    u1 u2 - uav
    red blue - color
    s1 s2 - sprayer
    p0 p1 p2 - position
  )

  (:init
    (landed u1)
    (landed u2)
    (empty u1)
    (empty u2)
    (uav-at u1 p0)
    (uav-at u2 p0)
    (sprayer-color s1 red)
    (sprayer-color s2 blue)
    (clear p1)
    (clear p2)
  )

  (:goal
    (and
      (painted p1 red)
      (painted p2 blue)
    )
  )
)
