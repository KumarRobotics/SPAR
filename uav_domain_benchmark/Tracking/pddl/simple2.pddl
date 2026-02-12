(define (problem tracking-simple-2)
  (:domain trackingdomain)
  (:objects u1 - uav p1 p2 - position)
  (:init 
    (at u1 p1)
    (current-goal p1)
    (next-goal p1 p2)
  )
  (:goal 
    (and (current-goal p2)
         (reach-subgoal p1))
  )
)
