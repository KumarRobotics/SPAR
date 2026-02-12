(define (problem tracking-hard-single-2)
  (:domain trackingdomain)
  (:objects u1 - uav 
            p1 p2 p3 p4 p5 p6 p7 p8 - position)
  (:init 
    (at u1 p1)

    ;; Map with alternative paths
    (next-uav p1 p2)
    (next-uav p2 p3)
    (next-uav p2 p4)
    (next-uav p3 p5)
    (next-uav p4 p5)
    (next-uav p5 p6)
    (next-uav p6 p7)
    (next-uav p6 p8)

    ;; goal chain
    (current-goal p2)
    (next-goal p2 p5)
    (next-goal p5 p6)
    (next-goal p6 p7)
  )
  (:goal 
    (and
      (reach-subgoal p2)
      (reach-subgoal p5)
      (reach-subgoal p6)
    )
  )
  (:metric minimize (cost))
)
