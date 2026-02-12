; single uav on medium map with a loop, where multiple paths lead to the goal

(define (problem nav-problem-2)
  (:domain NavDomain)
  (:objects
    uav1 - uav
    pos1 pos2 pos3 pos4 pos5 - position
  )
  (:init
    (at uav1 pos1)
    (connect pos1 pos2)
    (connect pos2 pos3)
    (connect pos3 pos4)
    (connect pos4 pos2) ; loop
    (connect pos3 pos5)
    (goal pos5)
    (= (cost) 0)
  )
  (:goal
    (finish)
  )
)
