; test take off + fly to + land

(define (problem medium-test-flight-chain)
  (:domain CeilingPaintDomain)

  (:objects
    u1 - uav
    p1 p2 p3 - position
  )

  (:init
    (landed u1)
    (uav-at u1 p1)
  )

  (:goal
    (and
      (landed u1)
      (uav-at u1 p3)
    )
  )
)
