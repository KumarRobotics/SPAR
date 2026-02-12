(define (problem long-push-chain)
  (:domain MovableObs)
  (:objects
    u1 - uav
    g1 - ugv
    p1 p2 p3 p4 p5 - position
  )
  (:init
    (at-uav u1 p2)
    (at-ugv g1 p1)
    (connect p1 p2) (connect p2 p3) (connect p3 p4) (connect p4 p5)
    (is-clear p1)
    (mov-obs p2)
    (clear p3)
    (clear p4)
    (clear p5)
    (= (cost) 0)
  )
  (:goal (and (mov-obs p5) (at-ugv g1 p4)))
)
