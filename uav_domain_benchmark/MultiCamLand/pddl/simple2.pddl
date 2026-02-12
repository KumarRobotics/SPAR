(define (problem simple-detect-down)
  (:domain Multicam)
  (:objects u1 - uav p1 p2 - position)
  (:init 
    (at u1 p1)
    (down p2 p1)
    (not (obs p2))
  )
  (:goal 
    (at u1 p2)
  )
)
