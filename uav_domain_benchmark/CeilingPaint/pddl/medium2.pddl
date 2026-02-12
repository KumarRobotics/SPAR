; test Pick-up  Take-off  Fly  Paint (multiple colors)
(define (problem medium-multicolor)
  (:domain CeilingPaintDomain)

  (:objects
    u1 - uav
    red blue - color
    s1 s2 - sprayer
    p1 p2 - position
  )

  (:init
    (landed u1)
    (empty u1)
    (uav-at u1 p1)
    (sprayer-color s1 red)
    (sprayer-color s2 blue)
    (clear p2)
  )

  (:goal
    (painted p2 blue)
  )
)
