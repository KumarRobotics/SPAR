; test take off + fly to
(define (problem test-fly)
  (:domain CeilingPaintDomain)

  (:objects
    u1 - uav
    p1 p2 - position
  )

  (:init
    (landed u1)
    (uav-at u1 p1)
  )

  (:goal
    (and
      (flying u1)
      (uav-at u1 p2)
    )
  )
)
