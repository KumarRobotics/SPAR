; test mark clear
(define (problem simple-test-mark-clear)
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
    (clear p2)
  )
)
