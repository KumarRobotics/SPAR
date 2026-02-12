(define (problem simple-detect-then-move)
  (:domain Multicam)
  (:objects u1 - uav p1 p2 - position)
  (:init 
    (at u1 p1)
    (left p2 p1)
    (see-left u1)
    (not (obs p2))
  )
  (:goal 
    (at u1 p2)
  )
)
