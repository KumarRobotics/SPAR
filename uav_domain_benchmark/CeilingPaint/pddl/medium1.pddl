; test pick up + take off + fly to + paint

(define (problem test-paint)
  (:domain CeilingPaintDomain)

  (:objects
    u1 - uav
    s1 - sprayer
    c1 - color
    p1 p2 - position
  )

  (:init
    (landed u1)
    (empty u1)
    (uav-at u1 p1)
    (sprayer-color s1 c1)
    (clear p2)
  )

  (:goal
    (painted p2 c1)
  )
)
