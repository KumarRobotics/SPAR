; one uav on medium map that has fork roads, don't go to the wrong way

(define (problem nav-problem-1)
  (:domain NavDomain)
  (:objects
    uav1 - uav
    pos1 pos2 pos3 pos4 - position
  )
  (:init
    (at uav1 pos1)
    (connect pos1 pos2)
    (connect pos2 pos3)
    (connect pos2 pos4)
    (goal pos3)
    (= (cost) 0)
  )
  (:goal
    (finish)
  )
)
