(define (problem detect-then-move)
  (:domain MovableObs)
  (:objects
    u1 - uav
    g1 - ugv
    p1 p2 - position
  )
  (:init
    (at-uav u1 p2)
    (at-ugv g1 p1)
    (connect p1 p2)
    (is-clear p1)
    (clear p2)  ; ground truth
    (= (cost) 0)
  )
  (:goal (at-ugv g1 p2))
)
