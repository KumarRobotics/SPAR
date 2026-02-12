(define (problem multi-uav-analysis)
  (:domain MovableObs)
  (:objects
    u1 u2 - uav
    g1 - ugv
    p1 p2 p3 p4 - position
  )
  (:init
    (at-uav u1 p2)
    (at-uav u2 p3)
    (at-ugv g1 p1)
    (connect p1 p2) (connect p2 p3) (connect p3 p4)
    (is-clear p1)
    (clear p2)
    (mov-obs p3)
    (clear p4)
    (= (cost) 0)
  )
  (:goal (and (mov-obs p4) (is-clear p3) (at-ugv g1 p3)))
)
