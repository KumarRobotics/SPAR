;test move
(define (problem simple-test-move)
  (:domain GridExplore)

  (:objects
    u1 - uav
    p1 p2 - position
  )

  (:init
    (at u1 p1)
    (connect p1 p2)
    (clear p2)
  )

  (:goal
    (at u1 p2)
  )
)
