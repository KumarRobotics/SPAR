(define (problem hard-full-rotation-path)
  (:domain Multicam)
  (:objects u1 - uav p1 p2 p3 p4 p5 p6 - position)
  (:init 
    (at u1 p1)
    (down p2 p1)
    (right p3 p2)
    (down p4 p3)
    (left p5 p4)
    (down p6 p5)

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
