(define (problem scan-path-then-travel)
  (:domain MovableObs)
  (:objects
    u1 - uav
    g1 - ugv
    p1 p2 p3 - position
  )
  (:init
    (at-uav u1 p2)
    (at-ugv g1 p1)
    (connect p1 p2) (connect p2 p3)
    (is-clear p1)
    (clear p2)
    (clear p3)
    (= (cost) 0)
  )
  (:goal (at-ugv g1 p3))
)
