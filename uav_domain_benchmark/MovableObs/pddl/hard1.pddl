(define (problem hard-path-with-obstacle-analysis)
  (:domain MovableObs)
  (:objects
    u1 - uav
    g1 - ugv
    p1 p2 p3 p4 - position
  )
  (:init
    (at-uav u1 p2)
    (at-ugv g1 p1)
    (connect p1 p2) (connect p2 p3) (connect p3 p4)
    (is-clear p1)
    (mov-obs p2)
    (clear p3)
    (fix-obs p4)
    (= (cost) 0)
  )
  (:goal (and 
  (is-clear p2) 
  (at-ugv g1 p2)
  ))
)
