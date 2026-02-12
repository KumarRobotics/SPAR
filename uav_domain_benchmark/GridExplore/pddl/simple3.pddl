; test mark clear and move
(define (problem simple-mark-then-move)
  (:domain GridExplore)

  (:objects
    u1 - uav
    p1 p2 - position
  )

  (:init
    (at u1 p1)
    (connect p1 p2)
    (not (obs p2)) 
  )

  (:goal
    (and
      (at u1 p2)
    )
  )
)
