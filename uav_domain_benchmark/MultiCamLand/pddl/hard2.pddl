(define (problem hard-zigzag-rotation)
  (:domain Multicam)
  (:objects u1 - uav p1 p2 p3 p4 p5 p6 - position)
  (:init 
    (at u1 p1)
    (right p2 p1)
    (down p3 p2)
    (left p4 p3)
    (down p5 p4)
    (right p6 p5)
    
    (see-left u1)
    
    (not (obs p2))
    (not (obs p3))
    (not (obs p4))
    (not (obs p5))
    (not (obs p6))
  )
  (:goal 
    (at u1 p6)
  )
)
