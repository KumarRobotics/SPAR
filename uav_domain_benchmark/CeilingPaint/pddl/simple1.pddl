; test pickup action in PDDL

(define (problem test-pickup)
  (:domain CeilingPaintDomain)

  (:objects
    u1 - uav
    s1 - sprayer
  )

  (:init
    (landed u1)
    (empty u1)
  )

  (:goal
    (holding u1 s1)
  )
)
