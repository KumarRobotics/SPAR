(define (problem tracking-hard-single-3)
  (:domain trackingdomain)
  (:objects u1 - uav 
            p1 p2 p3 p4 p5 p6 p7 p8 p9 - position)
  (:init 
    (at u1 p1)

    ;; complex graph
    (next-uav p1 p2)
    (next-uav p1 p3)
    (next-uav p2 p4)
    (next-uav p3 p4)
    (next-uav p4 p5)
    (next-uav p5 p6)
    (next-uav p5 p7)
    (next-uav p6 p8)
    (next-uav p7 p8)
    (next-uav p8 p9)

    ;; goal chain
    (current-goal p2)
    (next-goal p2 p4)
    (next-goal p4 p5)
    (next-goal p5 p8)
    (next-goal p8 p9)
  )
  (:goal 
    (and
      (reach-subgoal p2)
      (reach-subgoal p4)
      (reach-subgoal p5)
      (reach-subgoal p8)
    )
  )
  (:metric minimize (cost))
)
