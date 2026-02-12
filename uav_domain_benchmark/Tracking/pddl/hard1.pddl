(define (problem tracking-hard-single-1)
  (:domain trackingdomain)
  (:objects u1 - uav 
            p1 p2 p3 p4 p5 p6 - position)
  (:init 
    (at u1 p1)

    ;; map connectivity (complex structure)
    (next-uav p1 p2)
    (next-uav p1 p3)
    (next-uav p2 p4)
    (next-uav p3 p4)
    (next-uav p4 p5)
    (next-uav p5 p6)

    ;; goal tracking chain
    (current-goal p2)
    (next-goal p2 p4)
    (next-goal p4 p6)
  )
  (:goal 
    (and
      (reach-subgoal p2)
      (reach-subgoal p4)
    )
  )
  (:metric minimize (cost))
)
