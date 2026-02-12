; test Pick-up  Take-off  Fly  Paint (multiple colors and positions)

(define (problem medium-multilocation-multicolor)
  (:domain CeilingPaintDomain)

  (:objects
    u1 - uav
    red blue - color
    s1 s2 - sprayer
    p0 p1 p2 - position
  )

  (:init
    (landed u1)
    (empty u1)
    (uav-at u1 p0)
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
